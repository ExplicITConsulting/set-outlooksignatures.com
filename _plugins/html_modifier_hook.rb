# _plugins/html_modifier_hook.rb
# This plugin modifies the final HTML output of pages/documents by adding
# IDs to headings and inserting anchor links, using a post_render hook.
require 'nokogiri'
require 'set'

module Jekyll
  module HtmlModifierHook
    # No global ID tracking needed to match JS logic, which is per-document.
    # @@all_generated_ids_for_hook = Set.new # REMOVED

    # Register the hook to run after each page/document is fully rendered
    Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
      # Skip if doc.output is nil or empty (no content), or if it's the search.json page itself,
      # or if it's explicitly excluded from sitemap/indexing, or not an HTML document.
      next if doc.output.nil? [cite_start]|| doc.output.empty? [cite: 6]
      [cite_start]next if doc.url == '/search.json' || doc.data['sitemap_exclude'] [cite: 6, 7]
      # Basic check to ensure it's HTML content we can parse (e.g., not a static CSS/JS file)
      [cite_start]next unless doc.output.strip.start_with?('<') || doc.output.strip.start_with?('<!DOCTYPE') [cite: 7, 8]

      Jekyll.logger.debug "HtmlModifierHook:", "Processing post_render for: #{doc.url}"

      # Parse the final HTML output (`doc.output`) as an HTML fragment
      doc_fragment = Nokogiri::HTML.fragment(doc.output)

      # Track generated IDs for this specific document, matching JS's document-level scope
      document_generated_ids = Set.new

      headings_modified = false # Flag to see if any headings were found and modified

      # Iterate over all heading types (h1 to h6) within the final HTML fragment
      [cite_start]doc_fragment.css('h1, h2, h3, h4, h5, h6').each do |heading_element| [cite: 9]
        [cite_start]headings_modified = true [cite: 10]
        original_id = heading_element['id']
        final_id = nil

        Jekyll.logger.debug "HtmlModifierHook:", "  Found heading HTML: #{heading_element.to_html.strip.slice(0, 50)}..."
        Jekyll.logger.debug "HtmlModifierHook:", "  Original ID: #{original_id.inspect}"

        # Determine the final ID for the heading (matching JS logic)
        [cite_start]if original_id && !original_id.empty? [cite: 11]
          [cite_start]final_id = original_id [cite: 11]
          Jekyll.logger.debug "HtmlModifierHook:", "  Using existing ID: #{final_id}"
        else
          # Call the module method directly using self.slugify for JS-like slugification
          # JS slugification:
          # .toLowerCase().trim()
          # .replace(/[^a-z0-9\s-]/g, '') // Remove non-word characters
          # .replace(/\s+/g, '-');    // Replace spaces with dashes
          slug_base = HtmlModifierHook.js_slugify(heading_element.text)
          unique_slug = slug_base
          counter = 1
          # [cite_start]Ensure uniqueness only within this document, matching JS behavior [cite: 12]
          while document_generated_ids.include?(unique_slug)
            unique_slug = "#{slug_base}-#{counter}"
            counter += 1
          end
          final_id = unique_slug
          # Assign the generated ID to the HTML element in the DOM
          heading_element['id'] = final_id
          [cite_start]Jekyll.logger.debug "HtmlModifierHook:", "  Generated new ID: #{final_id}" [cite: 14]
        end

        # Add the final ID to the set for uniqueness tracking within this document
        document_generated_ids.add(final_id)
        # @@all_generated_ids_for_hook.add(final_id) # REMOVED: No global tracking for JS match

        # [cite_start]Insert the anchor link (🔗) as the first child of the heading [cite: 20]
        anchor = Nokogiri::XML::Node.new "a", doc_fragment
        anchor['href'] = "##{final_id}"
        [cite_start]anchor['class'] = "anchor-link" [cite: 15, 20]
        [cite_start]anchor.content = "🔗" [cite: 20]
        heading_element.add_child(anchor) # Add as a child, equivalent to insertBefore(anchor, heading.firstChild)
        Jekyll.logger.debug "HtmlModifierHook:", "  Anchor added. Heading now: #{heading_element.to_html.strip.slice(0, 100)}..."
      end

      if headings_modified
        # Update the document's final output (`doc.output`) with the modified HTML fragment
        doc.output = doc_fragment.to_html(encoding: 'UTF-8')
        [cite_start]Jekyll.logger.debug "HtmlModifierHook:", "Finished post_render for: #{doc.url}. Output updated." [cite: 16]
      else
        [cite_start]Jekyll.logger.debug "HtmlModifierHook:", "No headings modified in #{doc.url}." [cite: 16]
      end
    end

    # [cite_start]Helper function to slugify text, adapted to match JS logic precisely [cite: 19]
    # JS slugification:
    # .toLowerCase().trim()
    # .replace(/[^a-z0-9\s-]/g, '') // Remove non-word characters
    # .replace(/\s+/g, '-');    // Replace spaces with dashes
    def self.js_slugify(text)
      text.to_s.downcase.strip
        .gsub(/[^a-z0-9\s-]/, '') # Remove non-word characters
        .gsub(/\s+/, '-')        # Replace spaces with dashes
    end

    # This function is not directly used in the ID/anchor logic, but kept for completeness
    # if it's meant to be identical to search_data_collector.rb
    def self.strip_html_and_normalize(html_content)
      Nokogiri::HTML.fragment(html_content).text
        .gsub(/\s+/, ' ')
        .strip
    end
  end
end