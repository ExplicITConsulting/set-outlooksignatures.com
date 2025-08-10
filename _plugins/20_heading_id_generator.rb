require 'nokogiri'
require 'set'

module Jekyll
  class HeadingIdGenerator
    Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
      next unless doc.output.is_a?(String) && doc.output.strip.start_with?('<')
      next if doc.url == '/search.json' || doc.data['sitemap'] == false
      next if doc.output.include?('<meta http-equiv="refresh"')

      Jekyll.logger.info "HeadingIdGenerator:", "Processing #{doc.url || doc.path}..."

      # Parse the HTML fragment
      fragment = Nokogiri::HTML.fragment(doc.output)
      headings = fragment.css('h1, h2, h3, h4, h5, h6')

      # Track existing IDs to avoid duplicates
      existing_ids = Set.new(headings.map { |h| h['id'] }.compact)
      counter = 1

      headings.each do |heading|
        next if heading['id'] && !heading['id'].empty?

        # Generate a unique ID
        new_id = "heading-#{counter}"
        while existing_ids.include?(new_id)
          counter += 1
          new_id = "heading-#{counter}"
        end

        # Assign the ID
        heading['id'] = new_id
        existing_ids.add(new_id)
        counter += 1
      end

      # Replace only the modified headings in the original HTML
      modified_output = doc.output
      headings.each do |heading|
        original = heading.dup
        original.remove_attribute('id')
        original_html = original.to_s
        new_html = heading.to_s

        # Replace only the first occurrence of the original heading
        modified_output = modified_output.sub(original_html, new_html)
      end

      doc.output = modified_output
      Jekyll.logger.info "HeadingIdGenerator:", "Finished processing #{doc.url || doc.path}."
    end
  end
end
