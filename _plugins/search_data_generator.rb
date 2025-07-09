require 'nokogiri'
require 'json'
require 'uri' # For URI.encode_www_form_component for slug generation

module Jekyll
  class SearchDataGenerator < Generator
    safe true # Mark as safe if no external system access is needed

    # This ensures the generator runs after posts/pages are loaded and processed
    # (after markdown to HTML conversion). The default priority is :normal (100).
    # Setting it higher (e.g., :high) means it runs earlier, lower (e.g., :low) means later.
    # We want it to run after content is rendered to HTML, so :normal or even slightly lower is fine.
    priority :normal # Adjust if you have other plugins that might interfere

    def generate(site)
      Jekyll.logger.info "SearchDataGenerator:", "Generating structured search data with DOM parsing..."

      search_sections_data = []

      # Process posts
      site.posts.each do |post|
        process_document(post, search_sections_data, site)
      end

      # Process pages (excluding the search.json itself and other non-content pages)
      site.pages.each do |page|
        # Skip pages without a title, or the search.json template itself,
        # or any other pages that shouldn't be indexed (e.g., templates, assets)
        if page.data['title'] && page.url != '/search.json' && !page.data['sitemap_exclude']
          process_document(page, search_sections_data, site)
        end
      end

      # Store the generated data in site.data for access in Liquid templates
      site.data['search_sections_data'] = search_sections_data

      Jekyll.logger.info "SearchDataGenerator:", "Finished generating search data. Found #{search_sections_data.count} sections."
    end

    private

    def process_document(document, search_data_array, site)
      # document.content contains the HTML after Markdown conversion
      doc = Nokogiri::HTML(document.content)

      # Get the base URL for this document
      base_url = document.url

      # Track generated IDs to ensure uniqueness within this document
      generated_ids = Set.new # Use a Set for efficient lookup

      # Iterate over all heading types (h1 to h6)
      doc.css('h1, h2, h3, h4, h5, h6').each do |heading_element|
        original_id = heading_element['id']
        generated_id = nil

        # 1. Ensure the heading has an ID
        if original_id && !original_id.empty?
          generated_id = original_id
        else
          # Generate a slug from the heading text
          slug_base = slugify(heading_element.text)
          unique_slug = slug_base
          counter = 1
          # Ensure uniqueness within the current document's processed elements
          while generated_ids.include?(unique_slug) || site.data['existing_ids_global']&.include?(unique_slug) # Optional: check global existing IDs
            unique_slug = "#{slug_base}-#{counter}"
            counter += 1
          end
          generated_id = unique_slug
          heading_element['id'] = generated_id # Assign the ID back to the element in the DOM object

          # Add to the set of generated IDs for this document
          generated_ids.add(generated_id)
        end

        # Ensure the site object has a global set for all IDs if you want truly unique IDs across the entire site
        # This is more robust but requires tracking state in the site object.
        site.data['existing_ids_global'] ||= Set.new
        site.data['existing_ids_global'].add(generated_id)

        # 2. Extract section title and content
        section_title = heading_element.text.strip

        # Get content until the next heading or end of the document
        section_content_nodes = []
        current_node = heading_element.next_sibling
        while current_node
          # Stop if we hit another heading
          if ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'].include?(current_node.name)
            break
          end
          section_content_nodes << current_node
          current_node = current_node.next_sibling
        end

        # Convert collected nodes to HTML, strip tags, normalize whitespace
        # Ensure 'strip_html' is defined for Nokogiri. For this purpose, we can do it manually.
        # Alternatively, for cleaner text, just extract text content.
        # Let's extract raw text and then normalize.
        # You might want to filter out script/style tags more carefully here if they appear.
        section_content_html = section_content_nodes.map(&:to_html).join('')
        section_content = strip_html_and_normalize(section_content_html)

        # 3. Construct the URL with the anchor
        full_url = "#{base_url}##{generated_id}"

        # 4. Add to our search data array
        search_data_array << {
          "title"    => section_title,
          "content"  => section_content,
          "url"      => full_url,
          "date"     => document.data['date'] ? document.data['date'].to_s : nil, # Convert date to string
          "category" => document.data['category'] || nil, # Handle nil category
          "tags"     => document.data['tags'] || []        # Handle nil tags
        }
      end
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
      Nokogiri::HTML(html_content).text
        .gsub(/\s+/, ' ') # Replace multiple whitespaces (including newlines) with a single space
        .strip            # Remove leading/trailing whitespace
    end
  end
end