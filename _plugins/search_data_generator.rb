require 'nokogiri'
require 'json'
require 'uri'
require 'set'

module Jekyll
  class SearchDataGenerator < Generator
    safe true
    priority :normal # Ensure it runs after Markdown conversion

    # A global set to track all generated IDs across the entire site
    @@all_generated_ids = Set.new

    def generate(site)
      Jekyll.logger.info "SearchDataGenerator:", "Starting to process documents for search data and anchor links..."

      search_sections_data = []

      # Process posts
      site.posts.each do |post|
        process_document(post, search_sections_data, site)
      end

      # Process pages (excluding the search.json itself and other non-content pages)
      site.pages.each do |page|
        # Skip pages without a title, or the search.json template itself,
        # or any other pages that shouldn't be indexed (e.g., templates, assets, or data files)
        if page.data['title'] && page.url != '/search.json' && !page.data['sitemap_exclude'] && !page.path.include?('_data')
          process_document(page, search_sections_data, site)
        end
      end

      # Store the generated data in site.data for access in Liquid templates
      site.data['search_sections_data'] = search_sections_data

      Jekyll.logger.info "SearchDataGenerator:", "Finished processing. Found #{search_sections_data.count} sections."
    end

    private

    def process_document(document, search_data_array, site)
      Jekyll.logger.debug "SearchDataGenerator:", "Processing document: #{document.url}"

      # Parse the document.content as an HTML fragment.
      doc_fragment = Nokogiri::HTML.fragment(document.content)

      # Track generated IDs for this specific document to ensure uniqueness within it
      document_generated_ids = Set.new

      base_url = document.url

      # Iterate over all heading types (h1 to h6) within the fragment
      doc_fragment.css('h1, h2, h3, h4, h5, h6').each do |heading_element|
        original_id = heading_element['id']
        final_id = nil

        # Determine the final ID for the heading
        if original_id && !original_id.empty?
          final_id = original_id
          Jekyll.logger.debug "SearchDataGenerator:", "  Using existing ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
        else
          # Generate a slug from the heading text
          slug_base = slugify(heading_element.text)
          unique_slug = slug_base
          counter = 1
          # Ensure uniqueness: first within this document, then globally across the site
          while document_generated_ids.include?(unique_slug) || @@all_generated_ids.include?(unique_slug)
            unique_slug = "#{slug_base}-#{counter}"
            counter += 1
          end
          final_id = unique_slug
          # Assign the generated ID to the HTML element in the DOM
          heading_element['id'] = final_id
          Jekyll.logger.debug "SearchDataGenerator:", "  Generated new ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
        end

        # Add the final ID to the sets for uniqueness tracking
        document_generated_ids.add(final_id)
        @@all_generated_ids.add(final_id)

        # --- IMPORTANT: The following steps now run regardless of whether ID was original or generated ---

        # 1. Insert the anchor link (🔗)
        anchor = Nokogiri::XML::Node.new "a", doc_fragment # Create anchor node within this fragment's context
        anchor['href'] = "##{final_id}"
        anchor['class'] = "anchor-link"
        anchor.content = "🔗"

        heading_element.prepend_child(anchor)
        Jekyll.logger.debug "SearchDataGenerator:", "  Anchor added for ID: #{final_id}. Heading now: #{heading_element.to_html.strip.slice(0, 100)}..."


        # 2. Extract section title and content for search.json
        # The title is the text content of the heading element.
        # Remove the anchor icon from the title for search index if it was added.
        section_title = heading_element.text.sub('🔗', '').strip

        # Get content until the next heading or end of the document
        section_content_nodes = []
        current_node = heading_element.next_sibling
        while current_node
          # Stop if we hit another heading (any level)
          if ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'].include?(current_node.name)
            break
          end
          section_content_nodes << current_node
          current_node = current_node.next_sibling
        end

        # Convert collected nodes to HTML, strip tags, normalize whitespace
        section_content = strip_html_and_normalize(section_content_nodes.map(&:to_html).join(''))
        Jekyll.logger.debug "SearchDataGenerator:", "  Content snippet extracted for ID #{final_id}: #{section_content.slice(0, 100)}..."


        # 3. Construct the URL with the anchor
        full_url = "#{base_url}##{final_id}"

        # 4. Add to our search data array
        search_data_array << {
          "title"    => section_title,
          "subtitle" => "",
          "content"  => section_content,
          "url"      => full_url,
          "date"     => document.data['date'] ? document.data['date'].to_s : nil,
          "category" => document.data['category'] || nil,
          "tags"     => document.data['tags'] || []
        }
        Jekyll.logger.debug "SearchDataGenerator:", "  Added to search data: #{full_url}"
      end

      # Update the document's content with the modified HTML fragment
      document.content = doc_fragment.to_html(encoding: 'UTF-8')
      Jekyll.logger.debug "SearchDataGenerator:", "Finished processing document: #{document.url}. Content updated."
    end

    # Helper function to slugify text
    def slugify(text)
      text.to_s.downcase.strip
        .gsub(/[^a-z0-9\s-]/, '') # Remove non-word characters (excluding spaces and dashes)
        .gsub(/[\s_]+/, '-')      # Replace spaces/underscores with a single dash
        .gsub(/^-+|-+$/, '')      # Remove leading/trailing dashes
    end

    # Helper function to strip HTML and normalize whitespace
    def strip_html_and_normalize(html_content)
      Nokogiri::HTML.fragment(html_content).text
        .gsub(/\s+/, ' ') # Replace multiple whitespaces (including newlines) with a single space
        .strip            # Remove leading/trailing whitespace
    end
  end
end