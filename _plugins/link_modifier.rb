require 'uri'
require 'nokogiri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      site = @context.registers[:site]
      site_url = site.config['url']
      return input unless site_url

      # Get site hostname
      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        return input
      end

      # Normalize input to avoid malformed tags
      normalized_input = input.gsub(/>\s+</, '><').strip

      doc = Nokogiri::HTML.fragment(normalized_input)

      doc.css('a').each do |link|
        href = link['href']
        next unless href
        next if href.start_with?('mailto:') || href.start_with?('tel:')

        link_class_to_add = ''

        begin
          uri = URI.parse(href)

          if uri.scheme && uri.hostname
            # Absolute URL
            is_external = uri.hostname.downcase != site_hostname
            if is_external
              link_class_to_add = "mtrcs-external-link"
              link['target'] = '_blank'

              rel_attrs = (link['rel'] || '').split(/\s+/).reject(&:empty?)
              unless rel_attrs.include?('noopener') && rel_attrs.include?('noreferrer')
                rel_attrs << 'noopener' << 'noreferrer'
                link['rel'] = rel_attrs.uniq.join(' ')
              end
            else
              link_class_to_add = "mtrcs-internal-link"
            end
          else
            # Relative or fragment-only URL — treat as internal
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
          # Treat as internal if it's a fragment-only link
          if href.start_with?('#')
            current_classes = (link['class'] || '').split(/\s+/).reject(&:empty?)
            unless current_classes.include?('mtrcs-internal-link')
              current_classes << 'mtrcs-internal-link'
              link['class'] = current_classes.join(' ')
            end
          end
          next
        end
      end

      doc.to_s
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)
