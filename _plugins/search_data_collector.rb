# _plugins/search_data_collector.rb
# This plugin collects data for search.json by iterating through documents
# and predicting heading IDs. It does NOT modify the HTML content of documents.

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

    # This global set tracks all predicted IDs across the entire site for search purposes.
    # It must use the same ID generation logic as the HtmlModifierHook.
    @@all_predicted_ids_for_search = Set.new

    def generate(site)
      Jekyll.logger.info "SearchDataCollector:", "Starting to collect structured search data..."

      search_sections_data = []

      # Iterate through all posts to collect their data
      site.posts.each do |post|
        collect_document_data(post, search_sections_data, site)
      end

      # Iterate through all pages to collect their data
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

    def collect_document_data(document, search_data_array, site)
      Jekyll.logger.debug "SearchDataCollector:", "Collecting data for: #{document.url}"
      Jekyll.logger.debug "SearchDataCollector: Document Class: #{document.class}"
      Jekyll.logger.debug "SearchDataCollector: Document Path: #{document.path}"
      Jekyll.logger.debug "SearchDataCollector: Has Front Matter?: #{document.data.any?}"
      Jekyll.logger.debug "SearchDataCollector: Is Renderable?: #{document.respond_to?(:render) && !document.is_a?(Jekyll::StaticFile)}"
      Jekyll.logger.debug "SearchDataCollector: --- Document.content start (first 200 chars) ---"
      Jekyll.logger.debug document.content.to_s[0..199].gsub(/\n/, '\\n') # Log first 200 chars, escape newlines
      Jekyll.logger.debug "SearchDataCollector: --- Document.content end ---"

      # Parse the document.content (which should be HTML from Markdown conversion)
      doc_fragment = Nokogiri::HTML.fragment(document.content)
      document_predicted_ids = Set.new # Track predicted IDs for this specific document

      base_url = document.url

      doc_fragment.css('h1, h2, h3, h4, h5, h6').each do |heading_element|
        original_id = heading_element['id']
        final_id = nil

        # Predict the final ID using the same logic that the HtmlModifierHook will use
        if original_id && !original_id.empty?
          final_id = original_id
          Jekyll.logger.debug "SearchDataCollector:", "  Using existing ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
        else
          slug_base = slugify(heading_element.text)
          unique_slug = slug_base
          counter = 1
          # Ensure uniqueness: first within this document's prediction, then globally across all predicted IDs
          while document_predicted_ids.include?(unique_slug) || @@all_predicted_ids_for_search.include?(unique_slug)
            unique_slug = "#{slug_base}-#{counter}"
            counter += 1
          end
          final_id = unique_slug
          Jekyll.logger.debug "SearchDataCollector:", "  Predicted new ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
        end

        # Add to sets to maintain uniqueness prediction for the entire site for search purposes
        document_predicted_ids.add(final_id)
        @@all_predicted_ids_for_search.add(final_id)

        # Extract section title (no anchor icon added at this stage)
        section_title = heading_element.text.strip

        # Extract content until the next heading or end of the document
        section_content_nodes = []
        current_node = heading_element.next_sibling
        while current_node
          if ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'].include?(current_node.name)
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
          "title"    => section_title,
          "content"  => section_content,
          "url"      => full_url,
          "date"     => document.data['date'] ? document.data['date'].to_s : nil,
          "category" => document.data['category'] || nil,
          "tags"     => document.data['tags'] || []
        }
        Jekyll.logger.debug "SearchDataCollector:", "  Collected search data for ID: #{final_id}"
      end
    end

    # Helper function to slugify text (MUST be IDENTICAL to the one in html_modifier_hook.rb)
    def slugify(text)
      text.to_s.downcase.strip
        .gsub(/[^a-z0-9\s-]/, '') # Remove non-word characters (excluding spaces and dashes)
        .gsub(/[\s_]+/, '-')      # Replace spaces/underscores with a single dash
        .gsub(/^-+|-+$/, '')      # Remove leading/trailing dashes
    end

    # Helper function to strip HTML and normalize whitespace (MUST be IDENTICAL to the one in html_modifier_hook.rb)
    def strip_html_and_normalize(html_content)
      Nokogiri::HTML.fragment(html_content).text
        .gsub(/\s+/, ' ') # Replace multiple whitespaces (including newlines) with a single space
        .strip            # Remove leading/trailing whitespace
    end
  end
end