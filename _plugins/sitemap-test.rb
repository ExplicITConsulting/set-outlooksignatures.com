# This plugin combines pages and posts from all languages,
# sorts them, and generates a multilingual sitemap file.
# It uses the `:after_reset` hook to ensure all documents are available.

Jekyll::Hooks.register :site, :after_reset do |site|
  # Get all posts and pages from the site.
  # This hook runs before language-specific builds,
  # so all documents are available.
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

  # Create a new Jekyll page for the sitemap and add it to the site's pages.
  # This tells Jekyll to write the file during its build process.
  page = Jekyll::PageWithoutAFile.new(site, site.source, '/', 'sitemap-test.xml')
  page.content = output_content
  site.pages << page
end
