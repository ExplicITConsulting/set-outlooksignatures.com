require 'nokogiri'
require 'uri'
require 'set'

module Jekyll
  class HeadingIdGenerator
    Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
      next unless doc.output.is_a?(String) && doc.output.strip.start_with?('<')
      next if doc.url == '/search.json' || doc.data['sitemap'] == false
      next if doc.output.include?('<meta http-equiv="refresh"')

      Jekyll.logger.info "HeadingIdGenerator:", "Processing #{doc.url || doc.path} for missing heading IDs..."

      doc_fragment = Nokogiri::HTML.fragment(doc.output)
      all_headings = doc_fragment.css('h1, h2, h3, h4, h5, h6')
      counter = 1

      existing_ids = Set.new(all_headings.map { |h| h['id'] }.compact)

      all_headings.each do |heading_element|
        if heading_element['id'].nil? || heading_element['id'].empty?
          new_id = "heading-#{counter}"
          while existing_ids.include?(new_id)
            counter += 1
            new_id = "heading-#{counter}"
          end

          original_html = heading_element.to_s
          heading_element['id'] = new_id
          new_html = heading_element.to_s

          # Use a safe substitution to avoid formatting issues
          escaped_original = Regexp.escape(original_html)
          doc.output.sub!(Regexp.new(escaped_original), new_html)

          existing_ids.add(new_id)
          Jekyll.logger.info "HeadingIdGenerator:", " Assigned new ID: '#{new_id}' to a heading."
        else
          Jekyll.logger.info "HeadingIdGenerator:", " Heading already has ID: '#{heading_element['id']}'."
        end
        counter += 1
      end

      Jekyll.logger.info "HeadingIdGenerator:", "Finished processing #{doc.url || doc.path}."
    end
  end
end
