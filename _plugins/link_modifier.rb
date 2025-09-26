require 'uri'
require 'nokogiri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      site = @context.registers[:site]
      site_url = site.config['url']

      return input unless site_url

      # 1. Determine site hostname for comparison
      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        return input
      end

      # 2. Parse the HTML input
      doc = Nokogiri::HTML.fragment(input)

      # 3. Process each <a> tag
      doc.css('a').each do |link|
        href = link['href']
        next unless href
        next if href.start_with?('mailto:') || href.start_with?('tel:')

        begin
          uri = URI.parse(href)
          link_class_to_add = ''

          if uri.scheme && uri.hostname
            # Absolute URL
            is_external = uri.hostname.downcase != site_hostname
            if is_external
              link_class_to_add = "mtrcs-external-link"
              link['target'] = '_blank'
            else
              link_class_to_add = "mtrcs-internal-link"
            end
          else
            # Relative URL — treat as internal
            link_class_to_add = "mtrcs-internal-link"
          end
          # Add class if needed
          unless link_class_to_add.empty?
            current_classes = (link['class'] || '').split(/\s+/).reject(&:empty?)
            unless current_classes.include?(link_class_to_add)
              current_classes << link_class_to_add
              link['class'] = current_classes.join(' ')
            end
          end
        rescue URI::InvalidURIError, ArgumentError
          next
        end
      end
      # 4. Return modified HTML
      doc.to_s
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)
