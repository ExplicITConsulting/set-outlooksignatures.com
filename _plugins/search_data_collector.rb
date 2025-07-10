# _plugins/search_data_collector.rb
require 'nokogiri'
require 'uri' # For URI encoding

module Jekyll
  module HeadingSections
    def get_heading_sections_for_search(page_or_post)
      # Ensure we're working with a Jekyll::Page or Jekyll::Document object
      return [] unless page_or_post.respond_to?(:content)

      # Get the HTML content after Jekyll's rendering (Markdown to HTML)
      # page_or_post.content is already HTML here
      html_content = page_or_post.content

      doc = Nokogiri::HTML(html_content)

      # Prepare data for search.json
      document_title = page_or_post.data['title'] || page_or_post.basename_without_ext.capitalize
      page_url = page_or_post.url
      page_date = page_or_post.data['date'].nil? ? nil : page_or_post.data['date'].strftime("%Y-%m-%d")
      page_category = page_or_post.data['categories'].is_a?(Array) ? page_or_post.data['categories'].join(', ') : page_or_post.data['categories']
      page_tags = page_or_post.data['tags'].is_a?(Array) ? page_or_post.data['tags'] : []

      headings = doc.css('h1, h2, h3, h4, h5, h6')

      sections = []
      # IMPORTANT: Reset existing_slugs for each document processed
      # This ensures uniqueness is per document, matching the client-side JS.
      existing_slugs_in_document = {}

      # --- Handle content BEFORE the first heading ---
      # This will be considered the "introduction" section.
      first_heading = headings.first
      if first_heading
        pre_heading_content_nodes = []
        # Get all child nodes of the body before the first heading
        doc.css('body > *').each do |node|
          break if node == first_heading
          pre_heading_content_nodes << node
        end

        pre_heading_text = pre_heading_content_nodes.map do |node|
          node.text.strip # Get text content of pre-heading nodes
        end.compact.join("\n").strip

        unless pre_heading_text.empty?
          # Generate a slug for the introduction section (e.g., "introduction")
          intro_slug_base = "introduction"
          unique_intro_slug = intro_slug_base
          counter = 1
          while existing_slugs_in_document.key?(unique_intro_slug)
            unique_intro_slug = "#{intro_slug_base}-#{counter}"
            counter += 1
          end
          existing_slugs_in_document[unique_intro_slug] = true

          sections << {
            'documenttitle' => document_title,
            'sectiontitle' => "Introduction", # You can customize this
            'sectioncontent' => pre_heading_text,
            'url' => "#{page_url}##{unique_intro_slug}", # URL with anchor
            'date' => page_date,
            'category' => page_category,
            'tags' => page_tags
          }
        end
      elsif !doc.text.strip.empty? # No headings, but there's content
         sections << {
          'documenttitle' => document_title,
          'sectiontitle' => document_title, # Use document title as section title
          'sectioncontent' => doc.text.strip,
          'url' => page_url, # No specific anchor needed here
          'date' => page_date,
          'category' => page_category,
          'tags' => page_tags
         }
      end
      # --- End handling content BEFORE the first heading ---


      headings.each do |heading|
        # --- Slug generation matching js.txt ---
        # Generate a slug from the heading text [cite: 1]
        slug = heading.text
          .downcase # [cite: 1]
          .strip #
          .gsub(/[^\w\s-]/, '') # Remove non-word characters [cite: 1]
          .gsub(/\s+/, '-') # Replace spaces with dashes 

        # Ensure uniqueness by appending a number if needed 
        let_unique_slug = slug
        let_counter = 1
        while existing_slugs_in_document.key?(let_unique_slug) # Check uniqueness against slugs *in this document*
          let_unique_slug = "#{slug}-#{let_counter}"
          let_counter += 1
        end
        existing_slugs_in_document[let_unique_slug] = true # Store for uniqueness within this document
        # --- End slug generation ---

        # The ID on the heading itself might not exist yet, so we generate it
        # and assume the JS will later add it if it's not present.
        # For the purpose of URL generation, we use our generated unique slug.
        heading_id = let_unique_slug

        section_content_nodes = []
        current_node = heading.next_element || heading.next_sibling # Start with the next sibling

        while current_node
          # Check if the current node is a heading or if its name starts with 'h' followed by 1-6
          is_next_heading = current_node.node_type == Nokogiri::XML::Node::ELEMENT_NODE &&
                            current_node.name =~ /^h[1-6]$/

          if is_next_heading
            break # Stop if we hit the next heading
          end

          section_content_nodes << current_node
          current_node = current_node.next_element || current_node.next_sibling
        end

        # Extract PCDATA from the collected nodes for sectioncontent
        section_text = section_content_nodes.map do |node|
          # For elements, get their text content recursively (PCDATA)
          node.text.strip if node.node_type == Nokogiri::XML::Node::TEXT_NODE || node.node_type == Nokogiri::XML::Node::ELEMENT_NODE
        end.compact.join("\n").strip

        sections << {
          'documenttitle' => document_title,
          'sectiontitle' => heading.text.strip, # The text of the current heading
          'sectioncontent' => section_text,
          # URL including the anchor/hash/slug [cite: 3]
          'url' => "#{page_url}##{heading_id}",
          'date' => page_date,
          'category' => page_category,
          'tags' => page_tags
        }
      end

      sections
    end
  end
end

# Register the filter to be used in Liquid templates
Liquid::Template.register_filter(Jekyll::HeadingSections)