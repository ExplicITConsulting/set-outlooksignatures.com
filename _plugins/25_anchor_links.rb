# _plugins/25_anchor_links.rb

module Jekyll
  # This module adds anchor links to headings (h1-h6)
  class AnchorLinks
    def self.add_anchors(html)
      # Use a regular expression to find all heading tags with an id attribute.
      # Kramdown, Jekyll's default Markdown engine, automatically adds IDs to headings.
      html.gsub(/<(h[1-6])(.*?)id="([^"]+)"(.*?)>(.*?)<\/\1>/) do |match|
        # $1: heading tag (e.g., h2)
        # $2: attributes before id
        # $3: the id value
        # $4: attributes after id
        # $5: the inner HTML/text of the heading
        
        tag = $1
        pre_id_attrs = $2
        id = $3
        post_id_attrs = $4
        content = $5

        # Construct the new heading tag with the anchor link as the first child
        # The 'anchor-link' class is added for styling purposes.
        # The '🔗' character can be replaced with an SVG or other icon.
        "<#{tag}#{pre_id_attrs}id=\"#{id}\"#{post_id_attrs}>" +
        "<a href=\"##{id}\" class=\"anchor-link\" aria-hidden=\"true\">🔗</a>" +
        "#{content}</#{tag}>"
      end
    end
  end
end

# Register the plugin hook.
# This hook runs after a document (page, post) has been converted to HTML.
Jekyll::Hooks.register([:pages, :documents], :post_render) do |document|
  # Only modify HTML files
  if document.output_ext == '.html'
    document.output = Jekyll::AnchorLinks.add_anchors(document.output)
  end
end