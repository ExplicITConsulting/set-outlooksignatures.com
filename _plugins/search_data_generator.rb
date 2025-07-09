require 'nokogiri'
require 'json'
require 'uri' # For URI.encode_www_form_component for slug generation
require 'set' # For tracking unique IDs

module Jekyll
  class SearchDataGenerator < Generator
    safe true
    # We want this generator to run *after* all other content rendering (Markdown to HTML)
    # has completed, but *before* the files are written to disk.
    # A priority of :highest or just higher than :normal is usually good for this.
    # :normal (100) is fine if no other plugins modify HTML after this one.
    # Let's use :normal for now.
    priority :normal

    # A global set to track all generated IDs across the entire site
    # This helps ensure site-wide uniqueness if multiple documents could generate the same slug
    @@all_generated_ids = Set.new

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
        # or any other pages that shouldn't be indexed (e.g., templates, assets)
        if page.data['title'] && page.url != '/search.json' && !page.data['sitemap_exclude'] && !page.path.include?('_data')
          process_document(page, search_sections_data, site)
        end
      end

      # Store the generated data in site.data for access in Liquid templates
      site.data['search_sections_data'] = search_sections_data

      Jekyll.logger.info "SearchDataGenerator:", "Finished processing. Found #{search_sections_data.count} sections."
    end

    private

    # Processes a single document (post or page)
    # - Ensures headings have IDs and modifies the document's content with these IDs
    # - Inserts anchor links next to headings
    # - Extracts data for search.json
    def process_document(document, search_data_array, site)
      # document.content contains the HTML after Markdown conversion.
      # We need to parse this HTML to manipulate it.
      doc = Nokogiri::HTML(document.content)

      # Track generated IDs for this specific document to ensure uniqueness within it
      document_generated_ids = Set.new

      # Base URL for this document
      base_url = document.url

      # Iterate over all heading types (h1 to h6)
      doc.css('h1, h2, h3, h4, h5, h6').each do |heading_element|
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
        anchor = Nokogiri::XML::Node.new "a", doc
        anchor['href'] = "##{final_id}"
        anchor['class'] = "anchor-link" # Apply the same class as your JS
        anchor.content = "🔗" # Use the unicode character directly

        # Insert before the first child, or prepend if no children
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

        # Convert collected nodes to HTML, strip tags, normalize whitespace
        # Use a helper to get cleaner text
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

      # After processing all headings for this document, update the document's content
      # This is the crucial step that writes the modified HTML back into Jekyll's output pipeline.
      document.content = doc.to_html(encoding: 'UTF-8')
    end

    # Helper function to slugify text (similar to Jekyll's built-in slugify filter)
    def slugify(text)
      text.to_s.downcase.strip
        .gsub(/[^a-z0-9\s-]/, '') # Remove non-word characters (excluding spaces and dashes)
        .gsub(/[\s_]+/, '-')      # Replace spaces/underscores with a single dash
        .gsub(/^-+|-+$/, '')      # Remove leading/trailing dashes
    end

    # Helper function to strip HTML and normalize whitespace
    def strip_html_and_normalize(html_content)
      # Parse the snippet to handle nested tags correctly for text extraction
      Nokogiri::HTML(html_content).text
        .gsub(/\s+/, ' ') # Replace multiple whitespaces (including newlines) with a single space
        .strip            # Remove leading/trailing whitespace
    end
  end
end