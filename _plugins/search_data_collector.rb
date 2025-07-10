# _plugins/search_data_collector.rb
# This plugin collects data for search.json by iterating through documents
# and predicting heading IDs.
# It does NOT modify the HTML content of documents.

require 'nokogiri'
require 'json' # Not directly used for search_data_array, but often useful for other Jekyll generators.
require 'uri'
require 'set'

module Jekyll
  class SearchDataCollector < Generator
    safe true
    # This generator should run after Markdown conversion to HTML, but before Liquid rendering
    # of search.json.txt. Priority :normal is usually fine, but :high ensures it runs early.
    priority :normal # Changed from :high back to :normal as per the working example.

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
        else
          Jekyll.logger.info "SearchDataCollector:", "Skipping page due to filter: #{page.url || page.path}"
        end
      end

      # Store the collected data in site.data for access in Liquid templates (e.g., search.json.liquid)
      site.data['search_sections_data'] = search_sections_data

      Jekyll.logger.info "SearchDataCollector:", "Finished collecting search data. Found #{search_sections_data.count} sections."
    end

    private

    # Helper method that defines how to collect data for a single document
    def collect_document_data(document, search_data_array, site)
      Jekyll.logger.info "SearchDataCollector:", "Collecting data for: #{document.url || document.path}"
      Jekyll.logger.info "SearchDataCollector: Document Class: #{document.class}"
      Jekyll.logger.info "SearchDataCollector: Document Path: #{document.path}"
      Jekyll.logger.info "SearchDataCollector: Has Front Matter?: #{document.data.any?}"
      Jekyll.logger.info "SearchDataCollector: Is Renderable?: #{document.respond_to?(:content) && !document.is_a?(Jekyll::StaticFile)}"

      # Ensure document.content exists and is not empty before proceeding
      if document.content.nil? || document.content.strip.empty?
        Jekyll.logger.info "SearchDataCollector:", "   Document has no content or is empty. Skipping."
        return
      end

      content_to_parse = document.content
      Jekyll.logger.info "SearchDataCollector: --- Raw Document.content start (first 200 chars) ---"
      Jekyll.logger.info content_to_parse.to_s[0..199].gsub(/\n/, '\\n') # Log raw content
      Jekyll.logger.info "SearchDataCollector: --- Raw Document.content end ---"

      # CRITICAL: Convert Markdown to HTML if the document is a Markdown file
      if document.extname =~ /\.(md|markdown)$/i
        Jekyll.logger.info "SearchDataCollector:", "   Document is Markdown. Converting to HTML for parsing..."
        begin
          converter = site.find_converter_instance(Jekyll::Converters::Markdown)
          content_to_parse = converter.convert(document.content)
          Jekyll.logger.info "SearchDataCollector:", "   Markdown conversion successful."
        rescue => e
          Jekyll.logger.error "SearchDataCollector:", "   Error converting Markdown for #{document.url || document.path}: #{e.message}"
          content_to_parse = "" # Fallback to empty content if conversion fails
        end
      else
        Jekyll.logger.info "SearchDataCollector:", "   Document is not Markdown. Assuming HTML for parsing."
      end

      # If after conversion (or if it was already HTML) content is empty, skip.
      if content_to_parse.nil? || content_to_parse.strip.empty?
        Jekyll.logger.info "SearchDataCollector:", "   Content after conversion is empty. Skipping section extraction."
        return
      end
      
      doc_fragment = Nokogiri::HTML.fragment(content_to_parse)
      # Track predicted IDs for this specific document, matching JS's document-level scope
      document_predicted_ids = Set.new

      base_url = document.url

      # Get all heading elements in order
      all_headings = doc_fragment.css('h1, h2, h3, h4, h5, h6')
      Jekyll.logger.info "SearchDataCollector:", "   Found #{all_headings.size} headings in #{document.url || document.path}"

      # --- Handle content BEFORE the first heading ---
      # This will be considered the "introduction" section if it exists.
      first_heading_node = all_headings.first
      if first_heading_node
        pre_heading_content_nodes = []
        doc_fragment.children.each do |node|
          break if node == first_heading_node
          pre_heading_content_nodes << node
        end

        pre_heading_text = strip_html_and_normalize(pre_heading_content_nodes.map(&:to_html).join(''))

        unless pre_heading_text.empty?
          intro_slug_base = "introduction"
          unique_intro_slug = intro_slug_base
          counter = 1
          while document_predicted_ids.include?(unique_intro_slug)
            unique_intro_slug = "#{intro_slug_base}-#{counter}"
            counter += 1
          end
          document_predicted_ids.add(unique_intro_slug)

          search_data_array << {
            "documenttitle"  => document.data['title'] || nil,
            "sectiontitle"   => "Introduction",
            "sectioncontent" => pre_heading_text,
            "url"            => "#{base_url}##{unique_intro_slug}",
            "date"           => document.data['date'] ? document.data['date'].to_s : nil,
            "category"       => document.data['category'] || nil,
            "tags"           => document.data['tags'] || []
          }
          Jekyll.logger.info "SearchDataCollector:", "   Collected 'Introduction' section for #{document.url || document.path}"
        end
      elsif !doc_fragment.text.strip.empty? # No headings, but there's content for the whole page
        search_data_array << {
          "documenttitle"  => document.data['title'] || nil,
          "sectiontitle"   => document.data['title'] || "Page Content", # Use doc title as section title if no headings
          "sectioncontent" => strip_html_and_normalize(doc_fragment.to_html),
          "url"            => base_url, # No specific anchor needed here
          "date"           => document.data['date'] ? document.data['date'].to_s : nil,
          "category"       => document.data['category'] || nil,
          "tags"           => document.data['tags'] || []
        }
        Jekyll.logger.info "SearchDataCollector:", "   Collected full page content section (no headings) for #{document.url || document.path}"
      end
      # --- End handling content BEFORE the first heading ---

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
          # Ensure uniqueness only within this document's prediction, matching JS behavior
          while document_predicted_ids.include?(unique_slug)
            unique_slug = "#{slug_base}-#{counter}"
            counter += 1
          end
          final_id = unique_slug
          Jekyll.logger.info "SearchDataCollector:", "   Predicted new ID: #{final_id} for heading: #{heading_element.text.strip.slice(0, 50)}..."
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
        Jekyll.logger.info "SearchDataCollector:", "   Collected search data for ID: #{final_id}"
      end
    end

    # Helper function to slugify text, IDENTICAL to the js.txt logic
    def slugify(text)
      text.to_s.downcase.strip
        .gsub(/[^a-z0-9\s-]/, '') # Remove non-word characters
        .gsub(/\s+/, '-')        # Replace spaces with dashes
    end

    # Helper function to strip HTML and normalize whitespace, now excluding script and style tags.
    def strip_html_and_normalize(html_content)
      doc = Nokogiri::HTML.fragment(html_content)
      # Remove script and style tags
      doc.css('script, style').each(&:remove)
      doc.text
        .gsub(/\s+/, ' ')
        .strip
    end
  end
end
