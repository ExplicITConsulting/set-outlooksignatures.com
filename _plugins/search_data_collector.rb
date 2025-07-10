# _plugins/search_data_collector.rb
# This plugin collects data for search.json by iterating through documents
# and predicting heading IDs.
# It now runs post-render to include all generated HTML content.

require 'nokogiri'
require 'json'
require 'uri'
require 'set'

module Jekyll
  class SearchDataCollector
    # Register a hook to run after the entire site has been written (post-render)
    Jekyll::Hooks.register :site, :post_write do |site|
      Jekyll.logger.info "SearchDataCollector:", "Starting to collect structured search data (post-render)..."

      search_sections_data = []

      # Iterate through all posts and pages to collect their data
      # At this stage, document.output contains the fully rendered HTML
      (site.posts.docs + site.pages).each do |document|
        # Skip specific documents that shouldn't be indexed
        skip_reason = []
        should_process = true

        # Skip the search.json output file itself
        if document.url == '/search.json'
          skip_reason << "is search.json output file"
          should_process = false
        end
        # Skip pages explicitly marked for sitemap exclusion
        if document.data['sitemap_exclude']
          skip_reason << "sitemap_exclude is true"
          should_process = false
        end
        # Skip files within the _data directory (though these typically wouldn't have output)
        if document.path.include?('_data')
          skip_reason << "path includes _data"
          should_process = false
        end
        # Skip static files that don't have a 'output' property or meaningful content
        # This is crucial for performance and accuracy post-render
        unless document.respond_to?(:output) && !document.output.nil? && !document.output.strip.empty?
          skip_reason << "no renderable output"
          should_process = false
        end
        # Also skip binary files or files that are not HTML (e.g., images, CSS, JS)
        unless document.extname =~ /\.html?$/i || document.extname =~ /\.xml$/i # Include XML for sitemaps, RSS etc. if desired
          skip_reason << "not an HTML/XML file"
          should_process = false
        end


        if should_process
          collect_document_data(document, search_sections_data, site)
        else
          Jekyll.logger.debug "SearchDataCollector:", "Skipping document #{document.url || document.path} due to filter: #{skip_reason.join(', ')}"
        end
      end

      # Write the collected data directly to search.json in the destination directory
      search_json_path = File.join(site.dest, 'search.json')
      File.write(search_json_path, JSON.pretty_generate(search_sections_data))

      Jekyll.logger.info "SearchDataCollector:", "Finished collecting search data. Found #{search_sections_data.count} sections. Wrote to #{search_json_path}"
    end

    # Helper method that defines how to collect data for a single document
    # This method now expects document.output (fully rendered HTML)
    def self.collect_document_data(document, search_data_array, site)
      Jekyll.logger.debug "SearchDataCollector:", "Collecting data for: #{document.url || document.path}"
      Jekyll.logger.debug "SearchDataCollector: Document Class: #{document.class}"
      Jekyll.logger.debug "SearchDataCollector: Document Path: #{document.path}"
      Jekyll.logger.debug "SearchDataCollector: Has Front Matter?: #{document.data.any?}"
      Jekyll.logger.debug "SearchDataCollector: Has Output?: #{document.respond_to?(:output) && !document.output.nil? && !document.output.strip.empty?}"

      content_to_parse = document.output # Use the fully rendered output
      
      if content_to_parse.nil? || content_to_parse.strip.empty?
        Jekyll.logger.debug "SearchDataCollector:", "   Document output is empty. Skipping."
        return
      end

      Jekyll.logger.debug "SearchDataCollector: --- Rendered Document.output start (first 200 chars) ---"
      Jekyll.logger.debug content_to_parse.to_s[0..199].gsub(/\n/, '\\n') # Log raw content
      Jekyll.logger.debug "SearchDataCollector: --- Rendered Document.output end ---"

      doc_fragment = Nokogiri::HTML.fragment(content_to_parse)
      # Track predicted IDs for this specific document, matching JS's document-level scope
      document_predicted_ids = Set.new

      base_url = document.url

      # Get all heading elements in order
      all_headings = doc_fragment.css('h1, h2, h3, h4, h5, h6')
      Jekyll.logger.debug "SearchDataCollector:", "   Found #{all_headings.size} headings in #{document.url || document.path}"

      # --- Handle content BEFORE the first heading (as an "Introduction" section) ---
      first_heading_node = all_headings.first
      pre_heading_content_nodes = []
      if first_heading_node
        # Collect all nodes before the first heading
        doc_fragment.children.each do |node|
          break if node == first_heading_node
          pre_heading_content_nodes << node
        end
      else # If no headings at all, all content is "pre-heading"
        doc_fragment.children.each do |node|
          pre_heading_content_nodes << node
        end
      end

      pre_heading_text = strip_html_and_normalize(pre_heading_content_nodes.map(&:to_html).join(''))

      # If there's content before the first heading, or if there are no headings at all,
      # create an "Introduction" section using the document's title or a default.
      unless pre_heading_text.empty?
        section_title = document.data['title'] || "Page Content" # Use document title or a default
        intro_slug_base = slugify(section_title) # Use slugified title for ID
        unique_intro_slug = intro_slug_base
        counter = 1
        while document_predicted_ids.include?(unique_intro_slug)
          unique_intro_slug = "#{intro_slug_base}-#{counter}"
          counter += 1
        end
        document_predicted_ids.add(unique_intro_slug)

        search_data_array << {
          "documenttitle"  => document.data['title'] || nil,
          "sectiontitle"   => section_title,
          "sectioncontent" => pre_heading_text,
          "url"            => "#{base_url}##{unique_intro_slug}", # Use the slug for the URL anchor
          "date"           => document.data['date'] ? document.data['date'].to_s : nil,
          "category"       => document.data['category'] || nil,
          "tags"           => document.data['tags'] || []
        }
        Jekyll.logger.debug "SearchDataCollector:", "   Collected 'Introduction' section (using document title) for #{document.url || document.path}"
      end
      # --- End handling content BEFORE the first heading ---

      all_headings.each_with_index do |heading_element, index|
        original_id = heading_element['id']
        final_id = nil

        # Predict the final ID using the same logic that the JS will use
        if original_id && !original_id.empty?
          final_id = original_id
          Jekyll.logger.debug "SearchDataCollector:", "   Using existing ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
        else
          # Use the slugify function that matches the JS logic
          slug_base = slugify(heading_element.text)
          unique_slug = slug_base
          counter = 1
          # Ensure uniqueness only within this document's prediction, matching JS behavior
          while document_predicted_ids.include?(unique_slug)
            unique_slug = "#{slug_base}-#{counter}"
            counter += 1
          end
          final_id = unique_slug
          Jekyll.logger.debug "SearchDataCollector:", "   Predicted new ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
        end

        # Add to set to maintain uniqueness prediction for the current document
        document_predicted_ids.add(final_id)

        # Extract section title (no anchor icon added at this stage)
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

        # Add to our search data array
        search_data_array << {
          "documenttitle"  => document.data['title'] || nil,
          "sectiontitle"   => section_title,
          "sectioncontent" => "#{section_title} #{section_content}".strip, # Include section title in search content for better relevance
          "url"            => full_url,
          "date"           => document.data['date'] ? document.data['date'].to_s : nil,
          "category"       => document.data['category'] || nil,
          "tags"           => document.data['tags'] || []
        }
        Jekyll.logger.debug "SearchDataCollector:", "   Collected search data for ID: #{final_id}"
      end
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
