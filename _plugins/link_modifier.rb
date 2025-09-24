# _plugins/link_modifier.rb
require 'uri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      site_url = @context.registers[:site].config['url']
      
      # Use a single regex to capture the entire <a> tag and its href
      input.gsub(/<a(.*?)href="([^"]+)"(.*?)>/) do |match|
        pre_href = $1
        href = $2
        post_href = $3
        
        # Get the current classes from the tag, if they exist
        existing_classes = match.scan(/class=["']([^"']*)["']/).flatten.first || ''
        classes = existing_classes.split
        
        # Get the other attributes
        other_attrs = match.sub(existing_classes.strip, '').sub('class=', '')
        
        begin
          uri = URI.parse(href)
          
          # Handle mailto and javascript schemes gracefully
          if ['mailto', 'javascript'].include?(uri.scheme)
            # Add mtrcs-internal-link for mailto, and leave javascript alone
            if uri.scheme == 'mailto'
              classes << 'mtrcs-internal-link' unless classes.include?('mtrcs-internal-link')
              new_attrs = "href=\"#{href}\" class=\"#{classes.join(' ')}\""
              next "<a#{pre_href}#{new_attrs}#{post_href}>"
            end
            next match
          end
          
          is_external = uri.scheme && uri.hostname && uri.hostname.downcase != URI.parse(site_url).hostname.downcase

          if is_external
            # Add external link class and target
            classes << 'mtrcs-external-link' unless classes.include?('mtrcs-external-link')
            new_target = ' target="_blank"' unless match.include?('target="_blank"')
            
            # Rebuild the tag with new classes and target
            new_attrs = "href=\"#{href}\" class=\"#{classes.join(' ')}\"#{new_target}"
            
            # Add the arrow unless the no-external-link-icon class is present
            if !classes.include?('no-external-link-icon')
              # Check for the arrow before adding
              if !match.include?('&nbsp;↗</a>') && !match.include?('↗</a>')
                new_match = "<a#{pre_href}#{new_attrs}#{post_href}>".sub('</a', '&nbsp;↗</a')
                next new_match
              end
            end
            
            new_match = "<a#{pre_href}#{new_attrs}#{post_href}>"
            next new_match
          else
            # Add internal link class
            classes << 'mtrcs-internal-link' unless classes.include?('mtrcs-internal-link')
            
            # Rebuild the tag with new classes
            new_attrs = "href=\"#{href}\" class=\"#{classes.join(' ')}\""
            new_match = "<a#{pre_href}#{new_attrs}#{post_href}>"
            next new_match
          end
        rescue URI::InvalidURIError
          # Invalid URI, return the original match
          next match
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)