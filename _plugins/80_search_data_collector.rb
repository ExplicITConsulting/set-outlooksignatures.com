# _plugins/80_search_data_collector.rb

require 'nokogiri'
require 'json'
require 'uri'
require 'set'

module Jekyll
  class SearchDataCollector
    @@search_sections_data = []

    Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
      next if doc.output.nil? || doc.output.empty?
      next if doc.url == '/search.json' || doc.url == '/404.html' || doc.data['sitemap'] == false || doc.data['lang'] != doc.site.active_lang
      next if doc.data['redirect_to']
      next if doc.output.strip.start_with?("Redirecting") || doc.output.include?('<meta http-equiv="refresh"')
      next unless (doc.output.strip.start_with?('<') || doc.output.strip.start_with?('<!DOCTYPE')) &&
                   !['/sitemap.xml', '/feed.xml'].include?(doc.url)

      Jekyll.logger.info "SearchDataCollector:", "Processing document: #{doc.url || doc.path}"

      doc_fragment = Nokogiri::HTML.fragment(doc.output)
        if doc.site.active_lang == doc.site.default_lang
          base_url = doc.url
        else
          base_url = "/#{doc.site.active_lang}#{doc.url}"
        end

      all_headings = doc_fragment.css('h1, h2, h3, h4, h5, h6')
      Jekyll.logger.info "SearchDataCollector:", "  Found #{all_headings.size} headings in #{doc.url || doc.path}"

      all_headings.each_with_index do |heading_element, index|
        final_id = heading_element['id']

        # Skip this heading if it doesn't have an ID
        unless final_id && !final_id.empty?
          Jekyll.logger.info "SearchDataCollector:", "  Skipping heading without an ID: #{heading_element.text.strip.slice(0, 50)}..."
          next
        end

        # Create a temporary fragment to remove the anchor link from the section title text
        clean_heading_element = Nokogiri::HTML.fragment(heading_element.to_html)
        clean_heading_element.css('a.anchor-link').each(&:remove)
        section_title = clean_heading_element.text.strip.gsub(/\s+/, ' ')

        section_content_nodes = []
        current_node = heading_element.next_sibling

        next_heading = all_headings[index + 1]

        while current_node
          if next_heading && current_node == next_heading
            break
          end
          section_content_nodes << current_node
          current_node = current_node.next_sibling
        end

        section_content = strip_html_and_normalize(section_content_nodes.map(&:to_html).join(''))

        full_url = "#{base_url}##{final_id}"

        decoded_document_title = nil
        if doc.data['title']
          title_fragment = Nokogiri::HTML.fragment(doc.data['title'])
          title_fragment.css('a.anchor-link').each(&:remove)
          decoded_document_title = title_fragment.text
        end

        @@search_sections_data << {
          "document" => decoded_document_title,
          "section"  => section_title,
          "content"  => "#{section_content}".strip,
          "url"      => full_url,
          "date"     => doc.data['date'] ? doc.data['date'].to_s : "",
          "category" => doc.data['category'] || "",
          "tags"     => doc.data['tags'] && !doc.data['tags'].empty? ? doc.data['tags'].join(', ') : ""
        }
        Jekyll.logger.info "SearchDataCollector:", "  Collected search data for ID: #{final_id}"
      end
    end

    Jekyll::Hooks.register :site, :post_write do |site|
      Jekyll.logger.info "SearchDataCollector:", "Finished processing all documents. Writing search.json..."

      search_json_path = File.join(site.dest, 'search.json')
      File.write(search_json_path, JSON.pretty_generate(@@search_sections_data))

      Jekyll.logger.info "SearchDataCollector:", "Finished collecting search data. Found #{@@search_sections_data.count} sections. Wrote to #{search_json_path}"
      @@search_sections_data = []
    end

    def self.strip_html_and_normalize(html_content)
      doc = Nokogiri::HTML.fragment(html_content)
      # Remove the anchor links specifically
      doc.css('a.anchor-link').each(&:remove)
      doc.css('script, style').each(&:remove)
      doc.text
        .gsub(/\s+/, ' ')
        .strip
    end
  end
end
