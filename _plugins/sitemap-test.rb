# This plugin combines pages and posts, sorts them by language,
# and writes the result to a new sitemap file in the site's output directory.
# It hooks into the :post_write event of the jekyll-polyglot plugin.

Jekyll::Hooks.register :polyglot, :post_write do |site|
  # Get all posts and pages
  all_nodes = site.posts.docs.dup.concat(site.pages.dup)

  # Group nodes by their `page_id` front matter variable
  grouped_nodes = all_nodes.group_by { |node| node.data['page_id'] }

  # Get the site's default language and the full list of languages
  default_lang = site.config['default_lang'] || 'en'
  languages = site.config['languages'] || [default_lang]

  # Create a custom sort order map for languages
  lang_order = Hash.new(99) # Default high value for languages not in the list
  lang_order[default_lang] = 0 # Default language comes first
  languages.each_with_index do |lang, index|
    lang_order[lang] = index + 1
  end

  # Prepare the output content with the XML header
  output_content = <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  XML

  # Iterate through each group, sort it, and add to the output string
  grouped_nodes.each do |page_id, nodes|
    next unless page_id # Skip nodes without a page_id

    # Sort the nodes based on the custom language order
    sorted_nodes = nodes.sort_by { |node| lang_order[node.data['lang']] }

    # Add each sorted node's URL to the XML content
    sorted_nodes.each do |node|
      # Get the full URL, including the site's base URL
      full_url = "#{site.config['url']}#{node.url}"
      output_content << <<~URL_XML
        <url>
          <loc>#{full_url}</loc>
        </url>
      URL_XML
    end
  end

  # Close the XML file
  output_content << "</urlset>"

  # Create the file in the _site (destination) directory
  begin
    destination_path = File.join(site.dest, 'sitemap-test.xml')
    File.write(destination_path, output_content)
    Jekyll.logger.info "Successfully generated sitemap-test.xml"
  rescue => e
    Jekyll.logger.error "Error creating sitemap-test.xml: #{e.message}"
  end
end
