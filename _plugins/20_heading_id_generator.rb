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

      # Track the modified elements and their original HTML
      modified_elements = {}

      all_headings.each do |heading_element|
        if heading_element['id'].nil? || heading_element['id'].empty?
          new_id = "heading-#{counter}"
          while existing_ids.include?(new_id)
            counter += 1
            new_id = "heading-#{counter}"
          end

          heading_element['id'] = new_id
          existing_ids.add(new_id)
          Jekyll.logger.info "HeadingIdGenerator:", " Assigned new ID: '#{new_id}' to a heading."
          
          # Store the updated element's outer HTML and its original state for later replacement
          modified_elements[heading_element.to_s] = heading_element.to_s
        else
          Jekyll.logger.info "HeadingIdGenerator:", " Heading already has ID: '#{heading_element['id']}'."
        end
        counter += 1
      end

      # Perform a targeted replacement instead of re-serializing the entire document
      modified_elements.each do |original, modified|
        doc.output.sub!(original, modified)
      end
      
      Jekyll.logger.info "HeadingIdGenerator:", "Finished processing #{doc.url || doc.path}."
    end
  end
end