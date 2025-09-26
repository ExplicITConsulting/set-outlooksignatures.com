require 'uri'
require 'nokogiri' # Use Nokogiri directly, which is the standard

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
        return input
      end

      # 2. Parse the HTML input using Nokogiri::HTML.fragment for robust HTML parsing
      # This is the modern replacement for Nokogumbo.parse_fragment
      doc = Nokogiri::HTML.fragment(input)
      
      # 3. Select all <a> tags
      doc.css('a').each do |link|
        href = link['href']
        
        # Skip if no href attribute or it's a mailto/tel link
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
            
            # Ensure 'noopener noreferrer' is present in 'rel' attribute
            rel_attrs = (link['rel'] || '').split(/\s+/).reject(&:empty?)
            unless rel_attrs.include?('noopener') && rel_attrs.include?('noreferrer')
              rel_attrs << 'noopener' << 'noreferrer'
              link['rel'] = rel_attrs.uniq.join(' ')
            end
          else
            # Internal link logic (can be expanded if you need to differentiate internal types)
            link_class_to_add = "mtrcs-internal-link"
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
      # Using to_s is equivalent to to_html on a fragment and often cleaner
      doc.to_s
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkModifier)