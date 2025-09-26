require 'uri'
require 'nokogiri'

module Jekyll
  class LinkModifierHook
    def self.modify_links(html, site_url)
      return html unless site_url

      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        return html
      end

      doc = Nokogiri::HTML.fragment(html)

      doc.css('a').each do |link|
        href = link['href']
        next unless href
        next if href.start_with?('mailto:') || href.start_with?('tel:')

        link_class_to_add = ''

        begin
          uri = URI.parse(href)

          if uri.scheme && uri.hostname
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
            link_class_to_add = "mtrcs-internal-link"
          end

          current_classes = (link['class'] || '').split(/\s+/).reject(&:empty?)
          unless current_classes.include?(link_class_to_add)
            current_classes << link_class_to_add
            link['class'] = current_classes.join(' ')
          end
        rescue URI::InvalidURIError, ArgumentError
          if href.start_with?('#')
            current_classes = (link['class'] || '').split(/\s+/).reject(&:empty?)
            unless current_classes.include?('mtrcs-internal-link')
              current_classes << 'mtrcs-internal-link'
              link['class'] = current_classes.join(' ')
            end
          end
        end
      end

      doc.to_s
    end
  end
end

# Register the hook for pages and posts
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  site_url = doc.site.config['url']
  doc.output = Jekyll::LinkModifierHook.modify_links(doc.output, site_url)
end
