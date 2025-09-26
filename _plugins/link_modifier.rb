require 'uri'
require 'nokogumbo' # Ensure you have 'nokogumbo' and its dependency 'nokogiri' installed

module Jekyll
  module LinkModifier
    def modify_links(input)
      site = @context.registers[:site]
      site_url = site.config['url']
      
      return input unless site_url
      
      # 1. Determine site hostname for comparison
      begin
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        # If site_url itself is invalid, we can't reliably compare, so return original input
        return input
      end

      # 2. Parse the HTML input using Nokogumbo for robust HTML5 parsing
      # Nokogumbo.parse_fragment is suitable for partial HTML content (like page body)
      doc = Nokogumbo.parse_fragment(input)
      
      # 3. Select all <a> tags
      doc.css('a').each do |link|
        href = link['href']
        
        # Skip if no href attribute exists or it's a mailto/tel link
        next unless href
        if href.start_with?('mailto:') || href.start_with?('tel:')
          next
        end

        # Process the link
        begin
          uri = URI.parse(href)
          
          link_class_to_add = ''
          
          # 4. Determine link type and attributes to set
          # Check for scheme and hostname to consider it an external/absolute link
          is_absolute = uri.scheme && uri.hostname 
          is_external = is_absolute && uri.hostname.downcase != site_hostname
          
          if is_external
            link_class_to_add = "mtrcs-external-link"
            # Set external link attributes
            link['target'] = '_blank'
          elsif is_absolute || (uri.path && !uri.path.empty?)
            # Treat all other internal links (absolute or relative with a path)
            link_class_to_add = "mtrcs-internal-link"
          else
            # Skip fragments, only containing a query or simple relative links without a path
            next
          end

          # 5. Modify the class attribute
          unless link_class_to_add.empty?
            current_classes = (link['class'] || '').split(/\s+/).reject(&:empty?)
            
            # Append new class, ensuring no duplication
            unless current_classes.include?(link_class_to_add)
              current_classes << link_class_to_add
              link['class'] = current_classes.join(' ')
            end
          end
          
        rescue URI::InvalidURIError, ArgumentError
          # URI parsing failed for this specific href, skip it
          next
        end
      end
      
      # 6. Return the modified HTML content
      # #to_html on a fragment returns the concatenated content of its children
      doc.to_html(encoding: 'UTF-8', save_with: Nokogiri::XML::Node::SaveOptions::AS_HTML)
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)