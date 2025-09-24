# _plugins/link_modifier.rb
require 'uri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      site_url = @context.registers[:site].config['url']
      
      input.gsub(/<a([^>]*?)href="([^"]+)"([^>]*?)>/) do |match|
        href = $2

        # Check for schemes to ignore
        if href.start_with?('mailto:') || href.start_with?('tel:')
          next match
        end

        begin
          uri = URI.parse(href)

          new_attrs = ''
          new_class = ''
          
          existing_class_match = match.match(/class=["']([^"']*)["']/)
          if existing_class_match
            new_class = existing_class_match[1]
          end

          is_external = uri.scheme && uri.hostname && uri.hostname.downcase != URI.parse(site_url).hostname.downcase

          if is_external
            new_class += " mtrcs-external-link"
            new_attrs += ' target="_blank"'
          else
            new_class += " mtrcs-internal-link"
          end

          # Reconstruct the link's attributes. Do not touch the content.
          updated_match = match.sub(/class=["']([^"']*)["']/, '').sub("href=\"#{href}\"", "href=\"#{href}\"#{new_attrs}")
          
          unless new_class.strip.empty?
            updated_match = updated_match.sub("href=\"#{href}\"", "href=\"#{href}\" class=\"#{new_class.strip}\"")
          end
          
          updated_match

        rescue URI::InvalidURIError, ArgumentError
          next match
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)