# _plugins/add_heading_ids.rb

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # Only process HTML files
  next unless doc.output_ext == '.html'

  id_counter = 1
  # Use Nokogiri to parse and manipulate HTML
  require 'nokogiri'
  html = Nokogiri::HTML::DocumentFragment.parse(doc.output)

  html.css('h1, h2, h3, h4, h5, h6').each do |heading|
    unless heading.attributes['id']
      heading['id'] = "heading-#{id_counter}"
      id_counter += 1
    end
  end

  doc.output = html.to_html
end
