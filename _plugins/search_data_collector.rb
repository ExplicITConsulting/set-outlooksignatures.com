# _plugins/data_generator.rb
require 'nokogiri' # Make sure nokogiri is required if you haven't already in heading_sections.rb
require 'uri'
require 'yaml' # To output data as YAML

module Jekyll
  class SearchSectionsDataGenerator < Generator
    safe true
    priority :high # Run early to make data available

    def generate(site)
      Jekyll.logger.info "Jekyll Data Generator:", "Generating search_sections_data for _data/search_sections_data.yml"

      all_search_sections = []

      # Ensure the HeadingSections module is loaded (if not already by other means)
      unless site.data.key?('heading_sections_helper_loaded')
        # This is a bit of a hack: directly requiring the file might cause issues
        # if Jekyll's load order is different. A better way is to ensure
        # _plugins/heading_sections.rb defines a module/class that gets registered.
        # The best approach is to move the core logic into a reusable class/module
        # and then use it both as a Liquid filter AND here.
        # For simplicity, we'll assume the methods from HeadingSections are available.
        # If you run into "undefined method `get_heading_sections_for_search'",
        # you might need to combine the two plugin files or refactor slightly.
        #
        # For now, let's include the methods directly if not already available
        unless Jekyll::HeadingSections.respond_to?(:get_heading_sections_for_search)
          require_relative 'heading_sections' # Ensure your heading_sections.rb is in _plugins
        end
        site.data['heading_sections_helper_loaded'] = true # Prevent multiple loads if this runs again
      end

      # Get all pages and posts that are outputting HTML
      site.pages.each do |page|
        if page.output == true && page.content && page.ext == ".html"
          sections = Jekyll::HeadingSections.get_heading_sections_for_search(page)
          all_search_sections.concat(sections)
        end
      end

      site.posts.docs.each do |post| # For posts, use .docs
        if post.output == true && post.content && post.ext == ".html"
          sections = Jekyll::HeadingSections.get_heading_sections_for_search(post)
          all_search_sections.concat(sections)
        end
      end

      # Assign the generated data to site.data.search_sections_data
      # This makes it available in Liquid as site.data.search_sections_data
      site.data['search_sections_data'] = all_search_sections

      # Optionally, save it to a YAML file for inspection (not strictly necessary for site.data)
      # You can comment out the following lines if you don't need the actual file in _data
      # File.open(File.join(site.source, '_data', 'search_sections_data.yml'), 'w') do |f|
      #   f.write(all_search_sections.to_yaml)
      # end
      # Jekyll.logger.info "Jekyll Data Generator:", "Generated _data/search_sections_data.yml with #{all_search_sections.size} sections."
    end
  end
end