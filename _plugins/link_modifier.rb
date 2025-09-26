# _plugins/link_modifier.rb
require 'uri'

module Jekyll
  module LinkModifier
    def modify_links(input)
      site = @context.registers[:site]
      site_url = site.config['url']
      
      # 🚨 DEBUG: Confirm site URL is available
      Jekyll.logger.info "LinkModifier:", "Site URL configured: #{site_url || 'NIL (Plugin may not run correctly)'}"
      
      return input unless site_url
      
      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        Jekyll.logger.error "LinkModifier:", "Failed to parse site URL: #{site_url}. Plugin disabled."
        return input
      end

      # Regex to find all <a> tags.
      input.gsub(/<a([^>]*?)href="([^"]+)"([^>]*?)>/) do |match|
        href = $2

        if href.start_with?('mailto:') || href.start_with?('tel:')
          Jekyll.logger.debug "LinkModifier:", "Skipping #{href} (mailto/tel)."
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
            Jekyll.logger.info "LinkModifier:", "Identified external: #{href}"
          else
            # This handles #fragments and relative paths.
            link_class_to_add = " mtrcs-internal-link"
            Jekyll.logger.info "LinkModifier:", "Identified internal: #{href}"
          end

          if link_class_to_add.empty? && new_attrs.empty?
             next match
          end

          updated_match = match
          
          # 2. Modify the Class Attribute
          class_regex = /(class\s*=\s*['"])([^'"]*)(['"])/i 
          
          if updated_match.match(class_regex)
            # Class exists: Append the new class
            updated_match = updated_match.sub(class_regex) do |class_match|
              # $1 = quotes/class=, $2 = existing classes, $3 = closing quote
              "#{$1}#{$2}#{link_class_to_add.strip}#{$3}"
            end
            Jekyll.logger.debug "LinkModifier:", "Appended class '#{link_class_to_add.strip}' to existing classes."
          else
            # Class does not exist: Inject the new class attribute
            updated_match = updated_match.sub('<a', "<a class=\"#{link_class_to_add.strip}\"")
            Jekyll.logger.debug "LinkModifier:", "Injected class attribute with '#{link_class_to_add.strip}'."
          end
          
          # 3. Insert external attributes
          if !new_attrs.empty?
            updated_match = updated_match.sub("href=\"#{href}\"", "href=\"#{href}\"#{new_attrs}")
            Jekyll.logger.debug "LinkModifier:", "Injected external attributes: #{new_attrs.strip}"
          end
          
          # 🚨 DEBUG: Show the resulting tag
          Jekyll.logger.debug "LinkModifier:", "Original: #{match.strip}"
          Jekyll.logger.debug "LinkModifier:", "Modified: #{updated_match.strip}"
          
          updated_match

        rescue URI::InvalidURIError, ArgumentError => e
          # 🚨 DEBUG: Confirms if URI.parse is failing as you suspected
          Jekyll.logger.warn "LinkModifier:", "Skipping malformed link: #{href}. Error: #{e.message}. Full match: #{match.strip}"
          next match
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)