require 'uri'

module Jekyll
  module LinkModifier
    # Regex to capture the full opening tag, including newlines in attributes,
    # and isolate the href value. [^>]*? now includes \n.
    A_TAG_REGEX = /<a(.|\n)*?href="([^"]+)"(.|\n)*?>/i

    def modify_links(input)
      site = @context.registers[:site]
      site_url = @context.registers[:site].config['url']
      
      return input unless site_url
      
      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        return input
      end

      # Use the multiline-aware regex
      input.gsub(A_TAG_REGEX) do |match|
        # $2 still safely captures the href value due to the structure
        href = $2

        if href.start_with?('mailto:') || href.start_with?('tel:')
          next match
        end

        begin
          uri = URI.parse(href)

          new_attrs = ''
          link_class_to_add = ''
          
          # 1. Determine link type
          is_external = uri.scheme && uri.hostname && uri.hostname.downcase != site_hostname
          
          if is_external
            link_class_to_add = " mtrcs-external-link"
            new_attrs = ' target="_blank" rel="noopener noreferrer"'
          else
            link_class_to_add = " mtrcs-internal-link"
          end

          if link_class_to_add.empty? && new_attrs.empty?
             next match
          end

          updated_match = match
          
          # 2. Modify the Class Attribute (Robust Injection)
          class_regex = /(class\s*=\s*['"])([^'"]*)(['"])/i 
          
          if updated_match.match(class_regex)
            # Class exists: Use gsub with Regexp.last_match to append the new class safely
            updated_match = updated_match.gsub(class_regex) do |class_match|
              "#{ Regexp.last_match[1] }#{ Regexp.last_match[2] }#{link_class_to_add.strip}#{ Regexp.last_match[3] }"
            end
          else
            # Class does not exist: Inject the new class attribute
            # Use a substitution that is safe even with multiline matches
            updated_match = updated_match.sub(/<a/i, "<a class=\"#{link_class_to_add.strip}\"")
          end
          
          # 3. Insert external attributes
          if !new_attrs.empty?
            # Must handle multiline href attribute
            updated_match = updated_match.sub(/href\s*=\s*['"]#{Regexp.escape(href)}['"]/i, "href=\"#{href}\"#{new_attrs}")
          end
          
          updated_match

        rescue URI::InvalidURIError, ArgumentError
          # URI parsing failed, skip modification
          next match
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)