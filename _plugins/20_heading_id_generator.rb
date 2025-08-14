Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process HTML files
  next unless doc.output_ext == '.html'

  site_url = doc.site.config['url'].to_s.chomp('/')
  page_url = doc.url.to_s
  full_page_url = "#{site_url}#{page_url}"

  id_counter = 1

  # Add missing id attributes to headings
  regex_add_id = /<(h[1-6])\b(?![^>]*\bid=)([^>]*)>/i
  doc.output = doc.output.gsub(regex_add_id) do
    tag_name = Regexp.last_match(1)
    rest = Regexp.last_match(2)
    %Q{<#{tag_name} id="heading-#{id_counter}"#{rest}>}.tap { id_counter += 1 }
  end

  # Add data-content-name using the heading's id
  regex_add_matomo = /<(h[1-6])([^>]*)\bid="([^"]+)"([^>]*)>/i
  doc.output = doc.output.gsub(regex_add_matomo) do
    tag_name = Regexp.last_match(1)
    before_id = Regexp.last_match(2)
    heading_id = Regexp.last_match(3)
    after_id = Regexp.last_match(4)

    unless doc.output.include?("data-content-name=\"#{heading_id}\"")
      %Q{<#{tag_name}#{before_id}id="#{heading_id}"#{after_id} data-track-content="" data-content-name="#{full_page_url}##{heading_id}" data-content-piece="#{full_page_url}##{heading_id}" data-content-target="#{full_page_url}##{heading_id}">}
    else
      Regexp.last_match(0) # return original if already present
    end
  end
end
