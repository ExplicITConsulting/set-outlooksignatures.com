Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process HTML files
  next unless doc.output_ext == '.html'

  site_url = doc.site.config['url'].to_s.chomp('/')
  page_url = doc.url.to_s
  full_page_url = "#{site_url}#{page_url}"

  id_counter = 1

  # First, add missing id attributes to headings
  regex_id = /<(h[1-6])\b(?![^>]*\bid=)([^>]*)>/i
  doc.output = doc.output.gsub(regex_id) do
    tag_name = Regexp.last_match(1)
    rest = Regexp.last_match(2)
    %Q{<#{tag_name} id="heading-#{id_counter}"#{rest}>}.tap { id_counter += 1 }
  end

  # Second, add missing data-matomo-content-name attributes using the heading's id
  regex_matomo = /<(h[1-6])([^>]*?)\s*(?=>)/i
  doc.output = doc.output.gsub(regex_matomo) do
    tag_name = Regexp.last_match(1)
    rest = Regexp.last_match(2)

    # Extract existing id
    id_match = rest.match(/\bid="'["']/)
    heading_id = id_match ? id_match[1] : nil

    # Skip if no id found (shouldn't happen if first part ran correctly)
    next "<#{tag_name}#{rest}>" unless heading_id

    # Add data-matomo-content-name if missing
    if rest =~ /\bdata-matomo-content-name=/
      "<#{tag_name}#{rest}>"
    else
      %Q{<#{tag_name}#{rest} data-matomo-content-name="#{full_page_url}##{heading_id}">}
    end
  end
end
