require 'nokogiri'
require 'json'
require 'uri'
require 'set'

module Jekyll
  class SearchDataGenerator < Generator
    safe true
    priority :normal # Ensure it runs after Markdown conversion

    @@all_generated_ids = Set.new # Global set for site-wide unique ID tracking

    def generate(site)
      Jekyll.logger.info "SearchDataGenerator:", "Starting to process documents for search data and anchor links..."

      search_sections_data = []

      # Process posts
      site.posts.each do |post|
        process_document(post, search_sections_data, site)
      end

      # Process pages
      site.pages.each do |page|
        # Skip pages without a title, or the search.json template itself,
        # or any other pages that shouldn't be indexed (e.g., templates, assets, or data files)
        if page.data['title'] && page.url != '/search.json' && !page.data['sitemap_exclude'] && !page.path.include?('_data')
          process_document(page, search_sections_data, site)
        end
      end

      site.data['search_sections_data'] = search_sections_data
      Jekyll.logger.info "SearchDataGenerator:", "Finished processing. Found #{search_sections_data.count} sections."
    end

    private

    def process_document(document, search_data_array, site)
      # Parse the document.content as an HTML fragment.
      # Nokogiri::HTML.fragment is key here to avoid adding DOCTYPE, html, head, body.
      doc_fragment = Nokogiri::HTML.fragment(document.content)

      # Track generated IDs for this specific document to ensure uniqueness within it
      document_generated_ids = Set.new

      base_url = document.url

      # Iterate over all heading types (h1 to h6) within the fragment
      doc_fragment.css('h1, h2, h3, h4, h5, h6').each do |heading_element|
        original_id = heading_element['id']
        final_id = nil

        # 1. Ensure the heading has an ID
        if original_id && !original_id.empty?
          final_id = original_id
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
          heading_element['id'] = final_id # Assign the ID to the HTML element
        end

        # Add to sets for uniqueness tracking
        document_generated_ids.add(final_id)
        @@all_generated_ids.add(final_id)

        # 2. Insert the anchor link (🔗)
        anchor = Nokogiri::XML::Node.new "a", doc_fragment # Create anchor node within this fragment's context
        anchor['href'] = "##{final_id}"
        anchor['class'] = "anchor-link"
        anchor.content = "🔗"

        heading_element.prepend_child(anchor)

        # 3. Extract section title and content for search.json
        # The title is the text content of the heading element
        section_title = heading_element.text.sub('🔗', '').strip # Remove the anchor icon from the title for search index

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

        section_content = strip_html_and_normalize(section_content_nodes.map(&:to_html).join(''))

        # 4. Construct the URL with the anchor
        full_url = "#{base_url}##{final_id}"

        # 5. Add to our search data array
        search_data_array << {
          "title"    => section_title,
          "content"  => section_content,
          "url"      => full_url,
          "date"     => document.data['date'] ? document.data['date'].to_s : nil,
          "category" => document.data['category'] || nil,
          "tags"     => document.data['tags'] || []
        }
      end

      # Update the document's content with the modified HTML fragment
      # Use `to_html` (or `to_s`) on the fragment to get its content without wrappers.
      document.content = doc_fragment.to_html(encoding: 'UTF-8')
    end

    # Helper function to slugify text
    def slugify(text)
      text.to_s.downcase.strip
        .gsub(/[^a-z0-9\s-]/, '')
        .gsub(/[\s_]+/, '-')
        .gsub(/^-+|-+$/, '')
    end

    # Helper function to strip HTML and normalize whitespace
    def strip_html_and_normalize(html_content)
      # Nokogiri::HTML.fragment is also useful here for robust parsing of snippets
      Nokogiri::HTML.fragment(html_content).text
        .gsub(/\s+/, ' ')
        .strip
    end
  end
end