# _plugins/add_heading_ids_safe.rb

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process HTML files
  next unless doc.output_ext == '.html'

  # First, handle headings without IDs using the original logic
  id_counter = 1
  regex_no_id = /<(h[1-6])\b(?![^>]*\bid=)([^>]*?)>(.*?)<\/\1>/i

  doc.output = doc.output.gsub(regex_no_id) do |match|
    tag_name = Regexp.last_match(1)
    rest = Regexp.last_match(2)
    content = Regexp.last_match(3)
    
    # Create the new heading with an ID
    new_tag = %Q{<#{tag_name}#{rest} id="heading-#{id_counter}">#{content}</#{tag_name}>}
    id_counter += 1
    new_tag
  end

  # Second, handle all headings to add the Matomo attribute
  regex_all_headings = /<(h[1-6])([^>]*?)>(.*?)<\/\1>/i

  doc.output = doc.output.gsub(regex_all_headings) do |match|
    tag_name = Regexp.last_match(1)
    attributes = Regexp.last_match(2)
    content = Regexp.last_match(3)

    # Get the full URL of the page.
    full_url = doc.site.config['url'] + doc.url

    # Sanitize the heading content for a Matomo name.
    sanitized_content = content.strip.gsub(/<[^>]*>/, '')

    # Create the data-matomo-content-name attribute.
    matomo_name = %Q{ data-matomo-content-name="#{full_url} (#{sanitized_content})"}

    # Reconstruct the heading tag with the new attribute.
    %Q{<#{tag_name}#{attributes}#{matomo_name}>#{content}</#{tag_name}>}
  end
end