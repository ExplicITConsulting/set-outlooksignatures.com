require 'uri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      site = @context.registers[:site]
      site_url = site.config['url']
      return input unless site_url
      
      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        return input
      end

      # Regex to find all <a> tags with an href attribute.
      # $1 = All content/attributes inside <a> up to 'href='
      # $2 = href value
      # $3 = All content/attributes after href="..." up to the final '>'
      # The main regex captures the entire opening <a> tag, excluding the final >
      input.gsub(/<a([^>]*?)href="([^"]+)"([^>]*?)>/) do |match|
        href = $2

        if href.start_with?('mailto:') || href.start_with?('tel:')
          next match
        end

        begin
          uri = URI.parse(href)

          new_attrs = ''
          new_class = ''
          
          # 1. Extract existing classes
          existing_class_match = match.match(/class=["']([^"']*)["']/)
          if existing_class_match
            new_class = existing_class_match[1] # Start with existing classes
          end

          # 2. Determine link type
          is_external = uri.scheme && uri.hostname && uri.hostname.downcase != site_hostname
          
          if is_external
            new_class += " mtrcs-external-link"
            new_attrs += ' target="_blank" rel="noopener noreferrer"'
          else
            # This applies to #fragments, /quickstart, and relative paths
            new_class += " mtrcs-internal-link"
          end

          new_class = new_class.strip

          if new_class.empty? && new_attrs.empty?
             next match
          end

          # --- Corrected Link Reconstruction Logic ---
          
          # Remove the old class attribute if it exists
          updated_match = match.sub(/class=["']([^"']*)["']/, '')
          
          # Insert the new attributes (target/rel) after the href
          # Note: new_attrs is only non-empty for external links.
          updated_match = updated_match.sub("href=\"#{href}\"", "href=\"#{href}\"#{new_attrs}")
          
          # Insert the combined class attribute right after the opening <a tag
          # This is the most reliable injection point.
          unless new_class.empty?
            # Replaces '<a' with '<a class="..."'
            updated_match = updated_match.sub('<a', "<a class=\"#{new_class}\"")
          end
          
          # The closing '>' was part of the original match and should be preserved.
          updated_match

        rescue URI::InvalidURIError, ArgumentError
          next match
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)