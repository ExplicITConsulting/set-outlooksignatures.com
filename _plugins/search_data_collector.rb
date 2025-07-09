# frozen_string_literal: true

require 'nokogiri'

module Jekyll
  class SearchDataCollector < Generator
    safe true
    priority :lowest

    def generate(site)
      site.pages.each do |page|
        next unless page.output_ext == '.html'
        next unless page.output

        doc_fragment = Nokogiri::HTML.fragment(page.output)
        all_headings = doc_fragment.css('h1, h2, h3, h4, h5, h6')

        search_sections_data = []

        all_headings.each_with_index do |heading_element, index|
          heading_text = heading_element.text.strip
          next if heading_text.empty?

          # Generate slugified ID
          slug = slugify(heading_text)
          final_id = heading_element['id'] || slug
          heading_element['id'] ||= final_id

          # Collect all following siblings until the next heading or end of document
          section_content_nodes = []
          current_node = heading_element.next_sibling
          while current_node
            # Skip non-element nodes
            current_node = current_node.next_sibling while current_node && !current_node.element?
            break unless current_node
            # Stop if we reach the next heading
            break if current_node.name =~ /^h[1-6]$/
            # Skip <script> and <style> tags
            unless %w[script style].include?(current_node.name)
              section_content_nodes << current_node
            end
            current_node = current_node.next_sibling
          end

          section_content = section_content_nodes.map(&:text).join(' ').strip

          search_sections_data << {
            'sectiontitle' => heading_text,
            'sectioncontent' => "#{heading_text} #{section_content}".strip,
            'url' => "#{page.url}##{final_id}"
          }
        end

        site.data['search_sections_data'] ||= []
        site.data['search_sections_data'].concat(search_sections_data)
      end
    end

    private

    def slugify(text)
      text.to_s.downcase.strip
          .gsub(/[^a-z0-9\s\-]/, '') # Remove non-word characters
          .gsub(/\s+/, '-')          # Replace spaces with dashes
    end
  end
end
