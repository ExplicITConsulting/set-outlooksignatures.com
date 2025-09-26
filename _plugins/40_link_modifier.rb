require 'jekyll'
require 'uri'
require 'nokogiri' # Make sure you have the 'nokogiri' gem installed

module Jekyll
  class LinkModifierHook
    def self.modify_links_preserving_formatting_nokogiri(html, site_url)
      return html unless site_url

      begin
        # Use Nokogiri to parse the HTML fragment
        # The 'fragment' method is often better for parsing content snippets (like page body)
        doc = Nokogiri::HTML.fragment(html)
        site_hostname = URI.parse(site_url).hostname.downcase
      rescue URI::InvalidURIError, ArgumentError
        return html # Site URL is invalid
      rescue LoadError
        # Handle case where nokogiri gem might be missing
        Jekyll.logger.error "Nokogiri Error:", "The 'nokogiri' gem is required for this plugin."
        return html
      end

      # Select all anchor tags
      doc.css('a').each do |link|
        href = link['href']
        next unless href # Skip tags without an href attribute
        next if href.start_with?('mailto:', 'tel:', '#') # Skip special links

        # Determine link type
        is_external = begin
          uri = URI.parse(href)
          uri.scheme && uri.host && (uri.host.downcase != site_hostname)
        rescue URI::InvalidURIError
          false # Treat relative/invalid URLs as internal
        end

        class_to_add = is_external ? 'mtrcs-external-link' : 'mtrcs-internal-link'

        # 1. Add class attribute
        current_classes = (link['class'] || '').split
        unless current_classes.include?(class_to_add)
          new_classes = (current_classes + [class_to_add]).join(' ')
          link['class'] = new_classes
        end

        # 2. Add 'target' and 'rel' for external links
        if is_external
          # Add target="_blank"
          link['target'] = '_blank' unless link['target']

          # Add rel="noopener noreferrer"
          current_rel = (link['rel'] || '').split.map(&:downcase)
          rel_to_add = ['noopener', 'noreferrer']
          
          # Only add the missing rel attributes
          missing_rels = rel_to_add - current_rel
          if missing_rels.any?
            new_rel = (current_rel + missing_rels).join(' ')
            link['rel'] = new_rel.strip
          end
        end
      end

      # Convert the modified document fragment back to a string.
      # This is the step that can cause reformatting, but is necessary for Nokogiri.
      doc.to_html(encoding: 'UTF-8')
    end
  end
end

# Apply to all pages and documents
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  if doc.output && doc.output_ext == '.html'
    site_url = doc.site.config['url']
    # Use the Nokogiri-based modification method
    doc.output = Jekyll::LinkModifierHook.modify_links_preserving_formatting_nokogiri(doc.output, site_url)
  end
end