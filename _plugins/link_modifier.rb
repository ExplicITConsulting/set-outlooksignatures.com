# _plugins/link_modifier.rb
require 'uri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      site_url = @context.registers[:site].config['url']
      
      # The main gsub loop to find all <a> tags
      input.gsub(/<a([^>]*?)href="([^"]+)"([^>]*?)>/) do |match|
        href = $2

        # Check for schemes to ignore
        if href.start_with?('mailto:') || href.start_with?('tel:')
          next match
        end

        begin
          uri = URI.parse(href)

          # Existing logic to check for external vs. internal links and modify classes
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
            
            unless new_class.include?('no-external-link-icon')
              updated_match = match.sub(/<\/a>/, "&nbsp;↗</a>")
            else
              updated_match = match
            end
          else
            new_class += " mtrcs-internal-link"
            updated_match = match
          end

          updated_match = updated_match.sub(/class=["']([^"']*)["']/, '').sub("href=\"#{href}\"", "href=\"#{href}\"#{new_attrs}")
          
          unless new_class.strip.empty?
            updated_match = updated_match.sub("href=\"#{href}\"", "href=\"#{href}\" class=\"#{new_class.strip}\"")
          end
          
          updated_match

        rescue URI::InvalidURIError, ArgumentError
          # Fallback for any other unexpected invalid URIs
          next match
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)