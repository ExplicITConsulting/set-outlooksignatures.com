# _plugins/search_data_generator.rb
require 'nokogiri'
require 'uri'
require 'yaml'

module Jekyll
  module HeadingSections
    def self.get_heading_sections_for_search(page_or_post)
      Jekyll.logger.debug "HeadingSections:", "Processing item for sections: #{page_or_post.url || page_or_post.path}"
      
      return [] unless page_or_post.respond_to?(:content)

      html_content = page_or_post.content
      Jekyll.logger.debug "HeadingSections:", "HTML content length: #{html_content.length} for #{page_or_post.url || page_or_post.path}"
      
      # If content is empty or mostly whitespace, it won't yield sections
      if html_content.strip.empty?
        Jekyll.logger.warn "HeadingSections:", "Skipping (empty content): #{page_or_post.url || page_or_post.path}"
        return []
      end

      doc = Nokogiri::HTML(html_content)

      document_title = page_or_post.data['title'] || page_or_post.basename_without_ext.capitalize
      page_url = page_or_post.url
      page_date = page_or_post.data['date'].nil? ? nil : page_or_post.data['date'].strftime("%Y-%m-%d")
      page_category = page_or_post.data['categories'].is_a?(Array) ? page_or_post.data['categories'].join(', ') : page_or_post.data['categories']
      page_tags = page_or_post.data['tags'].is_a?(Array) ? page_or_post.data['tags'] : []

      headings = doc.css('h1, h2, h3, h4, h5, h6')
      Jekyll.logger.debug "HeadingSections:", "Found #{headings.size} headings for #{page_or_post.url || page_or_post.path}"

      sections = []
      existing_slugs_in_document = {} # Reset for each document

      # --- Handle content BEFORE the first heading ---
      first_heading = headings.first
      if first_heading
        pre_heading_content_nodes = []
        doc.css('body > *').each do |node|
          break if node == first_heading
          pre_heading_content_nodes << node
        end

        pre_heading_text = pre_heading_content_nodes.map do |node|
          node.text.strip
        end.compact.join("\n").strip

        unless pre_heading_text.empty?
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
            'sectiontitle' => "Introduction",
            'sectioncontent' => pre_heading_text,
            'url' => "#{page_url}##{unique_intro_slug}",
            'date' => page_date,
            'category' => page_category,
            'tags' => page_tags
          }
          Jekyll.logger.debug "HeadingSections:", "Added 'Introduction' section for #{page_or_post.url || page_or_post.path}"
        end
      elsif !doc.text.strip.empty? # No headings, but there's content
         sections << {
          'documenttitle' => document_title,
          'sectiontitle' => document_title,
          'sectioncontent' => doc.text.strip,
          'url' => page_url,
          'date' => page_date,
          'category' => page_category,
          'tags' => page_tags
         }
         Jekyll.logger.debug "HeadingSections:", "Added full content section (no headings) for #{page_or_post.url || page_or_post.path}"
      end
      # --- End handling content BEFORE the first heading ---

      headings.each do |heading|
        slug = heading.text
          .downcase
          .strip
          .gsub(/[^\w\s-]/, '')
          .gsub(/\s+/, '-')

        let_unique_slug = slug
        let_counter = 1
        while existing_slugs_in_document.key?(let_unique_slug)
          let_unique_slug = "#{slug}-#{let_counter}"
          let_counter += 1
        end
        existing_slugs_in_document[let_unique_slug] = true

        heading_id = let_unique_slug

        section_content_nodes = []
        current_node = heading.next_element || heading.next_sibling

        while current_node
          is_next_heading = current_node.node_type == Nokogiri::XML::Node::ELEMENT_NODE &&
                            current_node.name =~ /^h[1-6]$/

          if is_next_heading
            break
          end

          section_content_nodes << current_node
          current_node = current_node.next_element || current_node.next_sibling
        end

        section_text = section_content_nodes.map do |node|
          node.text.strip if node.node_type == Nokogiri::XML::Node::TEXT_NODE || node.node_type == Nokogiri::XML::Node::ELEMENT_NODE
        end.compact.join("\n").strip

        sections << {
          'documenttitle' => document_title,
          'sectiontitle' => heading.text.strip,
          'sectioncontent' => section_text,
          'url' => "#{page_url}##{heading_id}",
          'date' => page_date,
          'category' => page_category,
          'tags' => page_tags
        }
        Jekyll.logger.debug "HeadingSections:", "Added section for heading '#{heading.text.strip}' for #{page_or_post.url || page_or_post.path}"
      end

      Jekyll.logger.debug "HeadingSections:", "Returning #{sections.size} sections for #{page_or_post.url || page_or_post.path}"
      sections
    end
  end

  class SearchSectionsDataGenerator < Generator
    safe true
    priority :high

    def generate(site)
      Jekyll.logger.info "Jekyll Data Generator:", "Starting search_sections_data generation."

      all_search_sections = []

      # Iterate over pages
      site.pages.each do |page|
        # Only process pages that will be outputted as HTML and have content
        if page.output == true && page.content && page.ext == ".html"
          Jekyll.logger.debug "Jekyll Data Generator:", "Processing page: #{page.url}"
          sections = Jekyll::HeadingSections.get_heading_sections_for_search(page)
          all_search_sections.concat(sections)
        else
          Jekyll.logger.debug "Jekyll Data Generator:", "Skipping page (not output HTML or no content): #{page.url || page.path}"
        end
      end

      # Iterate over posts
      site.posts.docs.each do |post|
        # Only process posts that will be outputted as HTML and have content
        if post.output == true && post.content && post.ext == ".html"
          Jekyll.logger.debug "Jekyll Data Generator:", "Processing post: #{post.url}"
          sections = Jekyll::HeadingSections.get_heading_sections_for_search(post)
          all_search_sections.concat(sections)
        else
          Jekyll.logger.debug "Jekyll Data Generator:", "Skipping post (not output HTML or no content): #{post.url || post.path}"
        end
      end

      site.data['search_sections_data'] = all_search_sections
      Jekyll.logger.info "Jekyll Data Generator:", "Finished. Total search sections generated: #{all_search_sections.size}"
    end
  end
end