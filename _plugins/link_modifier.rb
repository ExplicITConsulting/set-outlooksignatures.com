# _plugins/link_modifier.rb
require 'uri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      # Get the current site URL from the Jekyll context
      site_url = @context.registers[:site].config['url']
      
      # Use a regular expression to find all <a> tags
      input.gsub(/<a[^>]*href="([^"]+)"[^>]*>/) do |match|
        href = $1
        
        # Parse the href to check if it's an external link
        begin
          uri = URI.parse(href)
          
          # Check if the href is a valid URI with a hostname
          if uri.scheme && uri.hostname
            # Check if the hostname is different from the site's hostname
            if uri.hostname.downcase != URI.parse(site_url).hostname.downcase
              # Add target="_blank" and the mtrcs-external-link class
              updated_match = match.sub("href=\"#{href}\"", "href=\"#{href}\" target=\"_blank\" class=\"mtrcs-external-link\"")
              
              # Add the arrow unless the no-external-link-icon class is present
              unless updated_match.include?('class="no-external-link-icon"')
                updated_match.sub(/<\/a>/, "&nbsp;↗</a>")
              else
                updated_match
              end
            else
              # Add the mtrcs-internal-link class for internal links
              match.sub("href=\"#{href}\"", "href=\"#{href}\" class=\"mtrcs-internal-link\"")
            end
          else
            # For relative links, add the mtrcs-internal-link class
            match.sub("href=\"#{href}\"", "href=\"#{href}\" class=\"mtrcs-internal-link\"")
          end
        rescue URI::InvalidURIError
          # If it's an invalid URL, return the original link
          match
        end
      end
    end
  end
end

# Register the filter with Jekyll
Liquid::Template.register_filter(Jekyll::LinkModifier)