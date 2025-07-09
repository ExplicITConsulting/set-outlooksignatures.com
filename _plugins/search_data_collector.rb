# _plugins/search_data_collector.rb
# This plugin collects data for search.json by iterating through documents
# and predicting heading IDs.
# It does NOT modify the HTML content of documents.

require 'nokogiri'
require 'json'
require 'uri'
require 'set'

module Jekyll
  class SearchDataCollector < Generator
    safe true
    # This generator should run after Markdown conversion to HTML.
    # Its priority can be normal, as it only collects data for site.data.
    priority :normal

    # REMOVED: The global ID tracking set is removed to match the JS and HtmlModifierHook logic,
    # which only ensures ID uniqueness within a single document.
    def generate(site)
      Jekyll.logger.info "SearchDataCollector:", "Starting to collect structured search data..."

      search_sections_data = []

      # Iterate through all posts to collect their data (using .docs.each for Jekyll 4+ compatibility)
      site.posts.docs.each do |post|
        collect_document_data(post, search_sections_data, site)
      end

      # Iterate through all pages to collect their data (site.pages is an Array, so just .each)
      site.pages.each do |page|
        # Skip specific pages (like search.json itself), excluded pages,
        # non-content files, and ensure it's a renderable document.
        if page.data['title'] && page.url != '/search.json' && !page.data['sitemap_exclude'] && !page.path.include?('_data') && page.respond_to?(:content) && !page.is_a?(Jekyll::StaticFile)
          collect_document_data(page, search_sections_data, site)
        end
      end

      # Store the collected data in site.data for access in Liquid templates (e.g., search.json.liquid)
      site.data['search_sections_data'] = search_sections_data

      Jekyll.logger.info "SearchDataCollector:", "Finished collecting search data. Found #{search_sections_data.count} sections."
    end

    private

    # Helper method that defines how to collect data for a single document
    def collect_document_data(document, search_data_array, site)
      Jekyll.logger.debug "SearchDataCollector:", "Collecting data for: #{document.url}"
      Jekyll.logger.debug "SearchDataCollector: Document Class: #{document.class}"
      Jekyll.logger.debug "SearchDataCollector: Document Path: #{document.path}"
      Jekyll.logger.debug "SearchDataCollector: Has Front Matter?: #{document.data.any?}"
      Jekyll.logger.debug "SearchDataCollector: Is Renderable?: #{document.respond_to?(:content) && !document.is_a?(Jekyll::StaticFile)}"
      Jekyll.logger.debug "SearchDataCollector: --- Raw Document.content start (first 200 chars) ---"
      Jekyll.logger.debug document.content.to_s[0..199].gsub(/\n/, '\\n') # Log raw content
      Jekyll.logger.debug "SearchDataCollector: --- Raw Document.content end ---"

      content_to_parse = document.content

      # CRITICAL FIX: Convert Markdown to HTML if the document is a Markdown file
      if document.extname =~ /\.(md|markdown)$/i
        Jekyll.logger.debug "SearchDataCollector:", "  Document is Markdown. Converting to HTML for parsing..."
        begin
          converter = site.find_converter_instance(Jekyll::Converters::Markdown)
          content_to_parse = converter.convert(document.content)
        rescue => e
          Jekyll.logger.error "SearchDataCollector:", "  Error converting Markdown for #{document.url}: #{e.message}"
          content_to_parse = "" # Fallback to empty content if conversion fails
        end
      else
        Jekyll.logger.debug "SearchDataCollector:", "  Document is not Markdown. Assuming HTML for parsing."
      end

      doc_fragment = Nokogiri::HTML.fragment(content_to_parse)
      # Track predicted IDs for this specific document, matching JS's document-level scope
      document_predicted_ids = Set.new

      base_url = document.url

      # Get all heading elements in order
      all_headings = doc_fragment.css('h1, h2, h3, h4, h5, h6')

      all_headings.each_with_index do |heading_element, index|
        original_id = heading_element['id']
        final_id = nil

        # Predict the final ID using the same logic that the HtmlModifierHook (and JS) will use
        if original_id && !original_id.empty?
          final_id = original_id
          Jekyll.logger.debug "SearchDataCollector:", "  Using existing ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
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
          Jekyll.logger.debug "SearchDataCollector:", "  Predicted new ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
        end

        # Add to set to maintain uniqueness prediction for the current document
        document_predicted_ids.add(final_id)

        # Extract section title (no anchor icon added at this stage)
        # Add .gsub(/\s+/, ' ') to normalize whitespace, including newlines
        section_title = heading_element.text.strip.gsub(/\s+/, ' ')

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
        Jekyll.logger.debug "SearchDataCollector:", "  Collected search data for ID: #{final_id}"
      end
    end

    # Helper function to slugify text, now IDENTICAL to the js_slugify in html_modifier_hook.rb
    def slugify(text)
      text.to_s.downcase.strip
        .gsub(/[^a-z0-9\s-]/, '') # Remove non-word characters
        .gsub(/\s+/, '-')        # Replace spaces with dashes
    end

    # Helper function to strip HTML and normalize whitespace (MUST be IDENTICAL to the one in html_modifier_hook.rb)
    def strip_html_and_normalize(html_content)
      Nokogiri::HTML.fragment(html_content).text
        .gsub(/\s+/, ' ')
        .strip
    end
  end
end