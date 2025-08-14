# _plugins/add_heading_ids_safe.rb

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process HTML files
  next unless doc.output_ext == '.html'

  id_counter = 1
  
  # This regex matches <h1>...<h6> tags that do NOT have an id= attribute
  # It captures the tag name (group 1), attributes (group 2), and content (group 3)
  regex = /<(h[1-6])(\b[^>]*?)>(.*?)<\/\1>/i

  doc.output = doc.output.gsub(regex) do
    tag_name = Regexp.last_match(1)
    attributes = Regexp.last_match(2)
    content = Regexp.last_match(3)
    
    # Get the full URL of the page
    full_url = doc.site.config['url'] + doc.url
    
    # Create the data-matomo-content-name attribute
    matomo_name = "#{full_url} (#{content.strip.gsub(/<[^>]*>/, '')})"
    
    # Check if an id attribute already exists to avoid duplication
    id_attribute = attributes.match(/\bid=/) ? "" : %Q{ id="heading-#{id_counter}"}
    
    # Build the new tag with the added attributes
    new_tag = %Q{<#{tag_name}#{attributes}#{id_attribute} data-matomo-content-name="#{matomo_name}">#{content}</#{tag_name}>}.tap { id_counter += 1 }
    new_tag
  end
end