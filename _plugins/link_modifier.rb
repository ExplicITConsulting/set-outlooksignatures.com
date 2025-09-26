require 'uri'

module Jekyll
  module LinkModifier
    # Use the 's' option in the regex for single-line mode, allowing '.' to match newlines
    # The regex matches the full opening <a> tag across multiple lines
    A_TAG_REGEX = /<a([^>]*?)href="([^"]+)"([^>]*?)>/im

    def modify_links(input)
      site = @context.registers[:site]
      site_url = site.config['url']
      
      return input unless site_url
      
      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        return input
      end

      # Use the multiline regex defined outside the method
      input.gsub(A_TAG_REGEX) do |match|
        href = $2

        if href.start_with?('mailto:') || href.start_with?('tel:')
          next match
        end

        begin
          uri = URI.parse(href)

          new_attrs = ''
          link_class_to_add = ''
          
          # 1. Determine link type
          # If no scheme or hostname, it's internal (#fragment, /relative/path)
          is_external = uri.scheme && uri.hostname && uri.hostname.downcase != site_hostname
          
          if is_external
            link_class_to_add = " mtrcs-external-link"
            new_attrs = ' target="_blank" rel="noopener noreferrer"'
          else
            # Internal (covers #fragment, /path#fragment, /path)
            link_class_to_add = " mtrcs-internal-link"
          end

          if link_class_to_add.empty? && new_attrs.empty?
             next match
          end

          updated_match = match
          
          # 2. Modify the Class Attribute (Robust Injection)
          # Captures: [1] = 'class="' or "class='", [2] = existing classes, [3] = closing quote
          class_regex = /(class\s*=\s*['"])([^'"]*)(['"])/i 
          
          if updated_match.match(class_regex)
            # Class exists: Use gsub with Regexp.last_match for safer attribute appending
            updated_match = updated_match.gsub(class_regex) do |class_match|
              # Append the new class to the captured existing classes
              "#{ Regexp.last_match[1] }#{ Regexp.last_match[2] }#{link_class_to_add.strip}#{ Regexp.last_match[3] }"
            end
          else
            # Class does not exist: Inject the new class attribute
            # Replaces the opening '<a' tag with '<a class="..."'
            updated_match = updated_match.sub('<a', "<a class=\"#{link_class_to_add.strip}\"")
          end
          
          # 3. Insert external attributes (only runs if new_attrs is not empty)
          if !new_attrs.empty?
            updated_match = updated_match.sub("href=\"#{href}\"", "href=\"#{href}\"#{new_attrs}")
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