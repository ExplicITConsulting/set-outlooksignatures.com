# _plugins/link_modifier.rb
require 'uri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      site_url = @context.registers[:site].config['url']
      
      input.gsub(/<a([^>]*?)href="([^"]+)"([^>]*?)>/) do |match|
        pre_href_attrs = $1
        href = $2
        post_href_attrs = $3

        begin
          uri = URI.parse(href)

          # Skip links without a scheme (e.g., #anchors) or special schemes
          next match unless uri.scheme.nil? || ['http', 'https', 'mailto'].include?(uri.scheme)

          new_attrs = ''
          new_class = ''
          
          # Extract existing classes and other attributes
          existing_class_match = match.match(/class=["']([^"']*)["']/)
          if existing_class_match
            new_class = existing_class_match[1]
          end

          # Check for external vs. internal
          is_external = uri.scheme && uri.hostname && uri.hostname.downcase != URI.parse(site_url).hostname.downcase

          if is_external
            new_class += " mtrcs-external-link"
            new_attrs += ' target="_blank"'
            
            # Add the arrow unless the no-external-link-icon class is present
            unless new_class.include?('no-external-link-icon')
              updated_match = match.sub(/<\/a>/, "&nbsp;↗</a>")
            else
              updated_match = match
            end
          else
            new_class += " mtrcs-internal-link"
            updated_match = match
          end

          # Rebuild the tag with new classes and attributes
          updated_match = updated_match.sub(/class=["']([^"']*)["']/, '').sub("href=\"#{href}\"", "href=\"#{href}\"#{new_attrs}")
          
          unless new_class.strip.empty?
            updated_match = updated_match.sub("href=\"#{href}\"", "href=\"#{href}\" class=\"#{new_class.strip}\"")
          end
          
          updated_match

        rescue URI::InvalidURIError
          # Catches any and all invalid URI formats, including $CurrentUserMail$
          match
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)