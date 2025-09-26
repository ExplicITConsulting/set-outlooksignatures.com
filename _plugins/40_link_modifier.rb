require 'jekyll'
require 'uri'

module Jekyll
  class LinkModifierHook
    def self.modify_links_preserving_formatting(html, site_url)
      return html unless site_url

      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        return html
      end

      # Regex to match <a> tags with href
      html.gsub(/<a\s+[^>]*href\s*=\s*"'["'][^>]*>/i) do |tag|
        href = $1.strip
        next tag if href.start_with?('mailto:', 'tel:')

        # Determine link type
        is_external = begin
          uri = URI.parse(href)
          uri.scheme && uri.host && uri.host.downcase != site_hostname
        rescue
          false
        end

        class_to_add = is_external ? 'mtrcs-external-link' : 'mtrcs-internal-link'

        # Add class if not present
        if tag =~ /class\s*=\s*"'["']/
          classes = $1.split
          unless classes.include?(class_to_add)
            new_classes = (classes + [class_to_add]).join(' ')
            tag.sub!(/class\s*=\s*["'][^"']*["']/, "class=\"#{new_classes}\"")
          end
        else
          tag.sub!(/>/, " class=\"#{class_to_add}\">")
        end

        # Add target and rel for external links
        if is_external
          tag = tag.sub(/>/, ' target="_blank" rel="noopener noreferrer">') unless tag.include?('target=')
        end

        tag
      end
    end
  end
end

# Apply to all pages and documents
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  site_url = doc.site.config['url']
  doc.output = Jekyll::LinkModifierHook.modify_links_preserving_formatting(doc.output, site_url)
end
