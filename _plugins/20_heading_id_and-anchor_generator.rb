# _plugins/20_heading_id_generator.rb

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process HTML files
  next unless doc.output_ext == '.html'

  site_url = doc.site.config['url'].to_s.chomp('/')
  page_url = doc.url.to_s
  full_page_url = "#{site_url}#{page_url}"
  
  id_counter = 1

  # This single regex will handle all the changes
  # It now captures any content, including nested HTML, between the heading tags.
  doc.output = doc.output.gsub(/<(h[2-6])([^>]*)>(.*?)<\/\1>/im) do |match|
    tag_name = Regexp.last_match(1)
    attributes = Regexp.last_match(2)
    content = Regexp.last_match(3)

    # Check for an existing 'id' attribute
    id_match = attributes.match(/id="([^"]+)"/i)
    
    heading_id = if id_match
                   id_match[1]
                 else
                   # If no ID exists, always create one using a counter
                   "heading-#{id_counter}".tap { id_counter += 1 }
                 end
    
    # Remove any old id to replace it with the new one
    sanitized_attributes = attributes.gsub(/id="[^"]*"/i, '').strip

    # Construct the full heading tag with all attributes
    new_heading_tag = "<#{tag_name} id=\"#{heading_id}\"#{sanitized_attributes}"

    # Add Matomo tracking attributes
    unless new_heading_tag.include?("data-content-name=")
      new_heading_tag += %Q{ data-track-content="" data-content-name="#{full_page_url}##{heading_id}" data-content-piece="#{full_page_url}##{heading_id}" data-content-target="#{full_page_url}##{heading_id}"}
    end

    # Close the opening tag
    new_heading_tag += ">"

    # Add the anchor link as the first child
    anchor_link = %Q{<a href="##{heading_id}" class="anchor-link">🔗</a>}

    # Reassemble the complete heading element
    "#{new_heading_tag}#{anchor_link}#{content}</#{tag_name}>"
  end
end