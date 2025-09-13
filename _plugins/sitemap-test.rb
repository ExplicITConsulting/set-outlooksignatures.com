require 'json' # Required for JSON.pretty_generate

Jekyll::Hooks.register :polyglot, :post_write do
  site = Jekyll.last_site

  # Start the output with the required front matter block
  output_content = <<~FRONTMATTER
    ---
    layout: none
    sitemap: false
    ---
  FRONTMATTER

  # Append the debugging information directly after the front matter.
  # Use string interpolation to safely embed variables.
  output_content << "\n--- Debugging Jekyll Polyglot Hook ---\n"
  
  # Check the state of the pages collection
  output_content << "site.pages is nil? #{site.pages.nil?}\n"
  output_content << "Number of pages: #{site.pages.size}\n"

  # Print the URLs of all pages to confirm their existence
  output_content << "Page URLs:\n"
  site.pages.each do |page|
    output_content << "  - #{page.url}\n"
  end
  
  # Check the state of the posts collection
  output_content << "site.posts is nil? #{site.posts.nil?}\n"
  output_content << "Number of posts: #{site.posts.docs.size}\n"

  # Print the URLs of all posts
  output_content << "Post URLs:\n"
  site.posts.docs.each do |post|
    output_content << "  - #{post.url}\n"
  end

  # Log the full dump of the configuration
  output_content << "Site configuration:\n"
  output_content << JSON.pretty_generate(site.config)
  
  output_content << "\n----------------------------------------\n"

  # Now, append the sitemap content after the debugging info
  output_content << <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  XML
  
  # Get all posts and pages
  all_nodes = site.posts.docs.dup.concat(site.pages.dup)

  # Group nodes by their `page_id` front matter variable
  grouped_nodes = all_nodes.group_by { |node| node.data['page_id'] }

  # Get the site's default language and the full list of languages
  default_lang = site.config['default_lang'] || 'en'
  languages = site.config['languages'] || [default_lang]

  # Create a custom sort order map for languages
  lang_order = Hash.new(99)
  lang_order[default_lang] = 0
  languages.each_with_index do |lang, index|
    lang_order[lang] = index + 1
  end

  # Iterate through each group, sort it, and add to the output string
  grouped_nodes.each do |page_id, nodes|
    next unless page_id

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