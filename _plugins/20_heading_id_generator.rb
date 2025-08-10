# _plugins/add_heading_ids_safe.rb

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process HTML files
  next unless doc.output_ext == '.html'

  id_counter = 1

  # This regex matches <h1> ... <h6> tags that do NOT have an id= attribute
  # and captures the start tag (group 1) and the rest of the tag name & attributes (group 2)
  regex = /<(h[1-6])\b(?![^>]*\bid=)([^>]*)>/i

  doc.output = doc.output.gsub(regex) do
    tag_name = Regexp.last_match(1)
    rest = Regexp.last_match(2)
    %Q{<#{tag_name} id="heading-#{id_counter}"#{rest}>}.tap { id_counter += 1 }
  end
end
