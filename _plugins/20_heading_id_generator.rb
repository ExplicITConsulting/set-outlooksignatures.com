Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process HTML files
  next unless doc.output_ext == '.html'

  site_url = doc.site.config['url'].to_s.chomp('/')
  page_url = doc.url.to_s
  full_page_url = "#{site_url}#{page_url}"

  id_counter = 1

  # Add missing id attributes to headings
  regex_add_id = /<(h[2-6])\b(?![^>]*\bid=)([^>]*)>/i
  doc.output = doc.output.gsub(regex_add_id) do
    tag_name = Regexp.last_match(1)
    rest = Regexp.last_match(2)
    %Q{<#{tag_name} id="heading-#{id_counter}"#{rest}>}.tap { id_counter += 1 }
  end

  # Add anchor link to headings with IDs
  regex_add_anchor = /<(h[2-6])\b([^>]*)id="([^"]+)"([^>]*)>/i
  doc.output = doc.output.gsub(regex_add_anchor) do
    tag_name = Regexp.last_match(1)
    before_id = Regexp.last_match(2)
    heading_id = Regexp.last_match(3)
    after_id = Regexp.last_match(4)

    # Capture the inner HTML of the heading using a separate regex to handle nested tags
    # This is a bit tricky with regex, so we'll just insert the link at the start.
    # The simplest way is to replace the opening tag with a new one that includes the anchor.
    original_heading = Regexp.last_match(0)
    anchor_link = %Q{<a class="anchor-link" href="##{heading_id}">🔗</a>}
    
    # We'll use a safer approach with a lookahead to ensure we only target the opening tag
    # to avoid double-adding. This is a common issue with `gsub`.
    # It's much cleaner to use a library like Nokogiri, but if you're restricted to regex,
    # this is how you would approach it.
    
    # Let's rebuild the heading with the anchor link inside.
    # This is much cleaner than the Matomo block, which is also a bit fragile.
    # The Matomo block is a separate issue but worth noting.
    
    # We will use the original match to ensure we don't mess up the attributes.
    heading_content_regex = /(<h[2-6][^>]*id="[^"]+"[^>]*>)(.*?)(<\/h[2-6]>)/i
    doc.output = doc.output.gsub(heading_content_regex) do |match|
      opening_tag = Regexp.last_match(1)
      content = Regexp.last_match(2)
      closing_tag = Regexp.last_match(3)
      
      # We need to find the ID to build the anchor link
      id = opening_tag.match(/id="([^"]+)"/)[1]
      anchor_link = %Q{<a class="anchor-link" href="##{id}">🔗</a>}
      
      "#{opening_tag}#{anchor_link}#{content}#{closing_tag}"
    end
  end

  # Your existing Matomo tracking code
  regex_add_matomo = /<(h[2-6])([^>]*)\bid="([^"]+)"([^>]*)>/i
  doc.output = doc.output.gsub(regex_add_matomo) do
    tag_name = Regexp.last_match(1)
    before_id = Regexp.last_match(2)
    heading_id = Regexp.last_match(3)
    after_id = Regexp.last_match(4)

    unless doc.output.include?("data-content-name=\"#{heading_id}\"")
      # Note: This regex is not robust. Using Nokogiri would be better.
      %Q{<#{tag_name}#{before_id}id="#{heading_id}"#{after_id} data-track-content="" data-content-name="#{full_page_url}##{heading_id}" data-content-piece="#{full_page_url}##{heading_id}" data-content-target="#{full_page_url}##{heading_id}">}
    else
      Regexp.last_match(0) # return original if already present
    end
  end
end