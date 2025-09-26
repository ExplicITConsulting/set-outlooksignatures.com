require 'jekyll'
require 'uri'

module Jekyll
  class LinkModifierHook
    # Regex to capture the entire opening <a> tag and its href attribute value.
    # It accounts for single or double quotes around the href value.
    A_TAG_REGEX = /<a\s+([^>]*?)\s*href\s*=\s*(["'])((?:(?!\2).)*)\2([^>]*?)>/im

    # Regex to find a class attribute within the captured attributes.
    CLASS_ATTR_REGEX = /class\s*=\s*(["'])((?:(?!\1).)*)\1/im

    def self.modify_links_preserving_formatting(html, site_url)
      return html unless site_url

      begin
        # Extract the site's hostname for comparison
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        # Return original HTML if site URL is invalid
        return html
      end

      # Iterate over all <a> tags and replace them with the modified version
      html.gsub(A_TAG_REGEX) do |full_tag|
        # Capture groups from A_TAG_REGEX:
        # $1: Attributes before href
        # $3: The href value (the actual URL)
        # $4: Attributes after href
        
        attributes_prefix = $1
        href = $3.strip
        attributes_suffix = $4

        # Skip special links
        next full_tag if href.start_with?('mailto:', 'tel:')

        # Determine link type
        is_external = begin
          uri = URI.parse(href)
          # Check if scheme and host exist, and if the host is different from the site's host
          uri.scheme && uri.host && (uri.host.downcase != site_hostname)
        rescue URI::InvalidURIError
          # Treat invalid/relative URLs as internal (or just don't flag as external)
          false
        end

        class_to_add = is_external ? 'mtrcs-external-link' : 'mtrcs-internal-link'

        new_attributes = ""
        class_added = false

        # 1. Modify or add the 'class' attribute
        if full_tag =~ CLASS_ATTR_REGEX
          # class found: $2 is the existing class list
          current_classes = $2.split
          unless current_classes.include?(class_to_add)
            # Add the new class to the list
            new_classes = (current_classes + [class_to_add]).join(' ')
            # Replace the old class attribute with the new one in the full_tag
            full_tag.sub!(CLASS_ATTR_REGEX, "class=\"#{new_classes}\"")
          end
          class_added = true
        else
          # Class not found: Add the class attribute to the end of the opening tag's attributes
          # Rebuild the attributes string for simplicity of insertion
          full_tag = full_tag.sub(/>/i, " class=\"#{class_to_add}\">")
          class_added = true
        end

        # 2. Add 'target' and 'rel' for external links if not present
        if is_external
          unless full_tag.include?('target=')
            # Insert the attributes before the closing '>' of the opening tag
            full_tag = full_tag.sub(/>/i, ' target="_blank">')
          end
          unless full_tag.include?('rel=')
            # Standard security/SEO rel attributes
            rel_attr = 'rel="noopener noreferrer"'
            if full_tag =~ /rel\s*=\s*(["'])/i
              # If rel exists, append to it
              full_tag.sub!(/rel\s*=\s*(["'])([^"']*)\1/i) { |m| "rel=\"#{$2.strip} noopener noreferrer\"" }
            else
              # Insert new rel attribute
              full_tag = full_tag.sub(/>/i, " #{rel_attr}>")
            end
          end
        end

        full_tag
      end
    end
  end
end

# Apply to all pages and documents
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process if the output is HTML (not nil and ends with .html)
  if doc.output && doc.output_ext == '.html'
    site_url = doc.site.config['url']
    doc.output = Jekyll::LinkModifierHook.modify_links_preserving_formatting(doc.output, site_url)
  end
end