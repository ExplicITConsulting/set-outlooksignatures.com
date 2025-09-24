# _plugins/20_heading_id_generator.rb

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

  # Add data-content-name using the heading's id and also add the anchor link
  regex_add_matomo_and_anchor = /<(h[2-6])([^>]*)\bid="([^"]+)"([^>]*)>(.*?)<\/\1>/i
  doc.output = doc.output.gsub(regex_add_matomo_and_anchor) do
    tag_name = Regexp.last_match(1)
    before_id = Regexp.last_match(2)
    heading_id = Regexp.last_match(3)
    after_id = Regexp.last_match(4)
    content = Regexp.last_match(5)

    # Reconstruct the heading tag with the Matomo tracking attributes
    new_heading_tag = unless doc.output.include?("data-content-name=\"#{heading_id}\"")
      %Q{<#{tag_name}#{before_id}id="#{heading_id}"#{after_id} data-track-content="" data-content-name="#{full_page_url}##{heading_id}" data-content-piece="#{full_page_url}##{heading_id}" data-content-target="#{full_page_url}##{heading_id}">}
    else
      Regexp.last_match(0)
    end
    
    # Add the anchor link as the first child of the heading
    anchor_link = %Q{<a href="##{heading_id}" class="anchor-link" aria-hidden="true">🔗</a>}
    
    # Combine the new heading tag, the anchor link, and the original content
    "#{new_heading_tag}#{anchor_link}#{content}</#{tag_name}>"
  end
end