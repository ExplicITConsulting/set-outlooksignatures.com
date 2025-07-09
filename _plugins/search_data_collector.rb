module Jekyll
  class SearchDataCollector < Generator
    safe true
    priority :normal

    def generate(site)
      Jekyll.logger.info "SearchDataCollector:", "Starting to collect structured search data..."

      search_sections_data = []

      site.posts.docs.each do |post|
        collect_document_data(post, search_sections_data, site)
      end

      site.pages.each do |page|
        if page.data['title'] && page.url != '/search.json' && !page.data['sitemap'] == false && page.html? && page.render?
          collect_document_data(page, search_sections_data, site)
        end
      end

      # Store the collected data in site.data
      site.data['search_sections_data'] = search_sections_data

      Jekyll.logger.info "SearchDataCollector:", "Finished collecting structured search data."
    end

    private

    def collect_document_data(document, search_data_array, site)
      # Parse the document content with Nokogiri
      doc = Nokogiri::HTML(document.content)

      base_url = Jekyll::URL.new(
        template:   document.url,
        placeholders: {
          :collection => document.collection.label,
          :path       => document.path,
          :output_ext => document.output_ext
        }
      ).generate(site.config)

      # Keep track of generated IDs within this document to ensure uniqueness
      document_ids = Set.new

      # Iterate over all heading elements (h1-h6)
      doc.css('h1, h2, h3, h4, h5, h6').each do |heading_element|
        final_id = nil
        predicted_id = nil

        # Extract section title (no anchor icon added at this stage)
        section_title = clean_text_for_search(heading_element.text)

        # Predict heading ID, matching HtmlModifierHook logic
        if heading_element['id']
          final_id = heading_element['id']
        else
          predicted_id = slugify(section_title)
          # Ensure ID uniqueness within this single document
          id_counter = 0
          temp_id = predicted_id
          while document_ids.include?(temp_id)
            id_counter += 1
            temp_id = "#{predicted_id}-#{id_counter}"
          end
          final_id = temp_id
        end

        document_ids.add(final_id)

        # Collect all nodes following the heading until the next heading or end of document
        section_content_nodes = []
        current_node = heading_element.next_sibling
        while current_node && !is_heading?(current_node)
          section_content_nodes << current_node
          current_node = current_node.next_sibling
        end

        # Strip HTML tags and normalize whitespace for search content
        section_content = strip_html_and_normalize(section_content_nodes.map(&:to_html).join(''))

        # Add to our search data array
        search_data_array << {
          "documenttitle"  => document.data['title'] || nil,
          "sectiontitle"   => section_title,
          "sectioncontent" => section_content,
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

    # Helper function to clean text for search indexing (from previous turn)
    def clean_text_for_search(text)
      text.to_s.strip
        .gsub(/[\u200B-\u200F\u2028-\u202F\uFEFF]/, '') # Remove common invisible Unicode characters
        .gsub(/[^[:alnum:]\s\-\_]/, '') # Remove non-alphanumeric, non-space, non-hyphen, non-underscore characters
        .gsub(/\s+/, ' ') # Normalize all whitespace to single spaces
    end

    # Modified helper function to strip HTML and normalize whitespace
    def strip_html_and_normalize(html_content)
      doc = Nokogiri::HTML(html_content)
      # Remove script and style tags before extracting text
      doc.xpath("//script | //style").each(&:remove)
      doc.text.gsub(/\s+/, ' ').strip
    end

    # Helper to check if a Nokogiri node is a heading
    def is_heading?(node)
      node.element? && ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'].include?(node.name)
    end
  end
end