require 'nokogiri'
require 'uri'
require 'set' # Added this line

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

      modified_html = doc.output

      all_headings.each do |heading_element|
        if heading_element['id'].nil? || heading_element['id'].empty?
          # Generate a new ID and ensure it's unique
          new_id = "heading-#{counter}"
          while existing_ids.include?(new_id)
            counter += 1
            new_id = "heading-#{counter}"
          end
          
          # Store the original and new HTML
          original_html = heading_element.to_s
          heading_element['id'] = new_id
          new_html = heading_element.to_s

          # Use a more robust substitution to avoid issues
          modified_html = modified_html.sub(original_html, new_html)

          existing_ids.add(new_id)
          Jekyll.logger.info "HeadingIdGenerator:", " Assigned new ID: '#{new_id}' to a heading."
        else
          Jekyll.logger.info "HeadingIdGenerator:", " Heading already has ID: '#{heading_element['id']}'."
        end
        counter += 1
      end

      # Update the document's output with the new IDs
      doc.output = modified_html
      
      Jekyll.logger.info "HeadingIdGenerator:", "Finished processing #{doc.url || doc.path}."
    end
  end
end