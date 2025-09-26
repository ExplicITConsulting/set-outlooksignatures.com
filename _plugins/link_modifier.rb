require 'uri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      # Guard clause: only run the filter if we have a site URL to compare against
      site = @context.registers[:site]
      site_url = site.config['url']
      return input unless site_url
      
      # Pre-parse the site hostname for comparison efficiency
      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        # If site_url is invalid, we can't perform external checks, so skip.
        return input
      end

      # Regex to find all <a> tags with an href attribute.
      # $1 = attributes before href (e.g., ' ')
      # $2 = href value (e.g., '#features' or 'https://external.com')
      # $3 = attributes after href (e.g., ' class="..." style="..."')
      input.gsub(/<a([^>]*?)href="([^"]+)"([^>]*?)>/) do |match|
        href = $2

        # 1. Check for schemes to ignore
        if href.start_with?('mailto:') || href.start_with?('tel:')
          next match
        end

        begin
          uri = URI.parse(href)

          new_attrs = ''
          new_class = ''
          
          # 2. Extract existing classes
          existing_class_match = match.match(/class=["']([^"']*)["']/)
          if existing_class_match
            new_class = existing_class_match[1] # Start with existing classes
          end

          # 3. Determine if link is external or internal (including fragments)
          is_external = uri.scheme && uri.hostname && uri.hostname.downcase != site_hostname
          
          # Links with no scheme/hostname (like /page.html or #fragment) are internal.
          if is_external
            new_class += " mtrcs-external-link"
            new_attrs += ' target="_blank" rel="noopener noreferrer"'
          else
            new_class += " mtrcs-internal-link"
          end

          new_class = new_class.strip # Remove potential leading/trailing spaces

          # 4. Reconstruct the link more reliably
          if new_class.empty? && new_attrs.empty?
             # Nothing to change
             next match
          end

          # Remove the old class attribute for clean re-insertion
          updated_match = match.sub(/class=["']([^"']*)["']/, '')
          
          # Add external attributes (target="_blank") after the href attribute
          updated_match = updated_match.sub("href=\"#{href}\"", "href=\"#{href}\"#{new_attrs}")
          
          # Insert the combined class attribute right after the opening <a tag
          unless new_class.empty?
            # Replace the leading '<a' tag with '<a class="..."'
            updated_match = updated_match.sub('<a', "<a class=\"#{new_class}\"")
          end
          
          updated_match

        rescue URI::InvalidURIError, ArgumentError
          # URI parsing failed, treat as-is
          next match
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)