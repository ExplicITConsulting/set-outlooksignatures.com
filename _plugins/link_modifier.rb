require 'uri'
require 'cgi'

module Jekyll
  module LinkModifier
    # Define the regex using Named Captures for clarity and robustness.
    # It allows any characters (including newlines) within the tag attributes.
    A_TAG_REGEX = /
      <a            # Match the opening tag
      (.|\n)*?      # Match attributes before href (non-greedy, including newlines)
      href=["']     # Match href attribute start
      (?<href_val>[^"']+) # Named Capture: href value (Group 2)
      ["']
      (.|\n)*?      # Match attributes after href
      >             # Match closing '>'
    /ix # i: case-insensitive, x: extended (allows comments/spacing), no 'm' needed with (.|\n)*?

    def modify_links(input)
      site = @context.registers[:site]
      site_url = site.config['url']
      return input unless site_url
      
      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        return input
      end

      # Decode HTML entities so regex works on actual HTML
      decoded_input = CGI.unescapeHTML(input)
      
      # Modify links
      modified = decoded_input.gsub(A_TAG_REGEX) do |match|
        # 🔑 FIX: Access href value using the named capture for safety.
        href = Regexp.last_match[:href_val]
        
        # Skip mailto and tel links
        if href.start_with?('mailto:') || href.start_with?('tel:')
          next match
        end
        
        begin
          uri = URI.parse(href)
          
          is_external = uri.scheme && uri.hostname && uri.hostname.downcase != site_hostname
          link_class_to_add = is_external ? " mtrcs-external-link" : " mtrcs-internal-link"
          new_attrs = is_external ? ' target="_blank" rel="noopener noreferrer"' : ''
          
          if link_class_to_add.strip.empty? && new_attrs.empty?
             next match
          end

          updated_match = match
          
          # Modify class attribute
          class_regex = /(class\s*=\s*['"])([^'"]*)(['"])/i
          
          if updated_match.match(class_regex)
            # Class exists: Use gsub with Regexp.last_match for appending
            updated_match = updated_match.gsub(class_regex) do 
              # Use indexed captures (1, 2, 3) which are reliable within this block's context
              "#{Regexp.last_match(1)}#{Regexp.last_match(2)}#{link_class_to_add.strip}#{Regexp.last_match(3)}"
            end
          else
            # Class does not exist: Inject the new class attribute
            updated_match = updated_match.sub(/<a/i, "<a class=\"#{link_class_to_add.strip}\"")
          end
          
          # Inject external attributes (uses multiline-safe regex for href)
          # Use Regexp.escape to ensure the href value doesn't break the substitution regex.
          updated_match = updated_match.sub(/href\s*=\s*['"]#{Regexp.escape(href)}['"]/i, "href=\"#{href}\"#{new_attrs}")
          
          updated_match
          
        rescue URI::InvalidURIError, ArgumentError
          next match
        end
      end
      
      # Re-encode HTML entities to restore the original format
      CGI.escapeHTML(modified)
    end
  end
end
Liquid::Template.register_filter(Jekyll::LinkModifier)