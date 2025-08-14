# _plugins/add_heading_ids_safe.rb

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process HTML files
  next unless doc.output_ext == '.html'

  # First, handle headings without IDs
  id_counter = 1
  regex_no_id = /<(h[1-6])\b(?![^>]*\bid=)([^>]*)>(.*?)<\/\1>/i

  doc.output = doc.output.gsub(regex_no_id) do
    tag_name = Regexp.last_match(1)
    rest = Regexp.last_match(2)
    content = Regexp.last_match(3)

    new_tag = %Q{<#{tag_name}#{rest} id="heading-#{id_counter}">#{content}</#{tag_name}>}
    id_counter += 1
    new_tag
  end

  # Second, add Matomo tracking attribute to all headings
  regex_all_headings = /<(h[1-6])([^>]*)>(.*?)<\/\1>/i

  doc.output = doc.output.gsub(regex_all_headings) do
    tag_name = Regexp.last_match(1)
    attributes = Regexp.last_match(2)
    content = Regexp.last_match(3)

    full_url = doc.site.config['url'].to_s + doc.url.to_s
    sanitized_content = content.strip.gsub(/<[^>]*>/, '')
    matomo_name = %Q{ data-matomo-content-name="#{full_url} (#{sanitized_content})"}

    %Q{<#{tag_name}#{attributes}#{matomo_name}>#{content}</#{tag_name}>}
  end
end
