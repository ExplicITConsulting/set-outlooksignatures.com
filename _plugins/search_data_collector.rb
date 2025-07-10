require 'nokogiri'
require 'json'
require 'uri'
require 'set'

module Jekyll
  class SearchDataCollector
    # Initialize a class variable to store collected data across all documents
    @@search_sections_data = []
    # Initialize a class variable to store predicted IDs across all documents to maintain uniqueness
    @@document_predicted_ids_global = Set.new

    # Register a hook to run after each individual page/document has been rendered
    Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
      # Skip if doc.output is nil or empty (no content), or if it's the search.json page itself,
      # or if it's explicitly excluded from sitemap/indexing.
      next if doc.output.nil? || doc.output.empty?
      next if doc.url == '/search.json' || doc.url == '/404.html' ||doc.data['sitemap_exclude']

      # Skip pages that are Jekyll redirects (using 'redirect_from'/'redirect_to' in front matter)
      # next if doc.data['redirect_from']
      next if doc.data['redirect_to']
      # Also skip pages whose *rendered content* is just a redirect message or meta refresh
      next if doc.output.strip.start_with?("Redirecting") || doc.output.include?('<meta http-equiv="refresh"')

      # Basic check to ensure it's HTML content we can parse (e.g., not a static CSS/JS file)
      # This is more robust than relying on .extname alone for post_render hook.
      # Also explicitly check for common XML files that might be Jekyll::Page objects.
      # Corrected: Changed start_with! to start_with?
      next unless (doc.output.strip.start_with?('<') || doc.output.strip.start_with?('<!DOCTYPE')) &&
                   !['/sitemap.xml', '/feed.xml'].include?(doc.url)

      Jekyll.logger.info "SearchDataCollector:", "Processing document: #{doc.url || doc.path}"

      # Parse the final HTML output (`doc.output`) as an HTML fragment
      doc_fragment = Nokogiri::HTML.fragment(doc.output)

      # Track predicted IDs for this specific document, matching JS's document-level scope
      # This needs to be per-document, so we'll pass a new Set to the helper method.
      document_predicted_ids_local = Set.new

      base_url = doc.url

      # Get all heading elements in order
      all_headings = doc_fragment.css('h1, h2, h3, h4, h5, h6')
      Jekyll.logger.info "SearchDataCollector:", "   Found #{all_headings.size} headings in #{doc.url || doc.path}"

      # --- Removed handling content BEFORE the first heading (as an "Introduction" section) ---

      all_headings.each_with_index do |heading_element, index|
        original_id = heading_element['id']
        final_id = nil

        # Predict the final ID using the same logic that the JS will use
        if original_id && !original_id.empty?
          final_id = original_id
          Jekyll.logger.info "SearchDataCollector:", "   Using existing ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
        else
          # Use the slugify function that matches the JS logic
          slug_base = slugify(heading_element.text)
          unique_slug = slug_base
          counter = 1
          # Ensure uniqueness within the current document's predicted IDs
          while document_predicted_ids_local.include?(unique_slug)
            unique_slug = "#{slug_base}-#{counter}"
            counter += 1
          end
          final_id = unique_slug
          Jekyll.logger.info "SearchDataCollector:", "   Predicted new ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
        end

        # Add to set to maintain uniqueness prediction for the current document
        document_predicted_ids_local.add(final_id)

        # Extract section title (no anchor icon added at this stage)
        # heading_element.text automatically decodes entities
        section_title = heading_element.text.strip.gsub(/\s+/, ' ') # Normalize whitespace

        section_content_nodes = []
        current_node = heading_element.next_sibling

        # Determine the end point for content collection for this section
        # If there's a next heading, that's the end. Otherwise, it's the end of the document.
        next_heading = all_headings[index + 1]

        while current_node
          # If the current node is the next heading, stop collecting content for this section
          if next_heading && current_node == next_heading
            break
          end
          section_content_nodes << current_node
          current_node = current_node.next_sibling
        end

        # Strip HTML tags and normalize whitespace for search content
        section_content = strip_html_and_normalize(section_content_nodes.map(&:to_html).join(''))

        # Construct the URL with the predicted anchor
        full_url = "#{base_url}##{final_id}"

        # Decode HTML entities in the document title for the documenttitle field
        decoded_document_title = doc.data['title'] ? Nokogiri::HTML.fragment(doc.data['title']).text : nil

        # Add to our search data array
        @@search_sections_data << { # Add to global array
          "document" => decoded_document_title, # Use decoded title for documenttitle
          "section"  => section_title,
          "content"  => "#{section_content}".strip,
          "url"      => full_url,
          "date"     => doc.data['date'] ? doc.data['date'].to_s : "",
          "category" => doc.data['category'] || "",
          "tags"     => doc.data['tags'] && !doc.data['tags'].empty? ? doc.data['tags'].join(', ') : ""
        }
        Jekyll.logger.info "SearchDataCollector:", "   Collected search data for ID: #{final_id}"
      end
    end

    # Register a hook to run after the entire site has been written to write the final JSON
    Jekyll::Hooks.register :site, :post_write do |site|
      Jekyll.logger.info "SearchDataCollector:", "Finished processing all documents. Writing search.json..."

      # Write the collected data directly to search.json in the destination directory
      search_json_path = File.join(site.dest, 'search.json')
      File.write(search_json_path, JSON.pretty_generate(@@search_sections_data))

      Jekyll.logger.info "SearchDataCollector:", "Finished collecting search data. Found #{@@search_sections_data.count} sections. Wrote to #{search_json_path}"
      # Clear the data for subsequent builds if Jekyll server is running
      @@search_sections_data = []
      @@document_predicted_ids_global = Set.new
    end


    # Helper function to slugify text, IDENTICAL to the js.txt logic
    def self.slugify(text)
      text.to_s.downcase.strip
        .gsub(/[^a-z0-9\s-]/, '') # Remove non-word characters
        .gsub(/\s+/, '-')        # Replace spaces with dashes
    end

    # Helper function to strip HTML and normalize whitespace, now excluding script and style tags.
    def self.strip_html_and_normalize(html_content)
      doc = Nokogiri::HTML.fragment(html_content)
      # Remove script and style tags
      doc.css('script, style').each(&:remove)
      doc.text
        .gsub(/\s+/, ' ')
        .strip
    end
  end
end