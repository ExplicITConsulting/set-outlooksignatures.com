# _plugins/50_sitemap_generator.rb

module Jekyll
  class SitemapGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Check if the 'sitemap_pages' collection is defined in _config.yml
      if site.config['collections'].key?('sitemap_pages')
        # Initialize the collection as a Jekyll::Collection object
        # The 'site' argument is required for initialization.
        sitemap_collection = Jekyll::Collection.new(site, 'sitemap_pages')

        # Get all documents from pages and posts
        # The .to_a method is used to ensure we are working with arrays
        # and not internal Jekyll collections.
        all_documents = site.posts.to_a.concat(site.pages.to_a)

        # Assign the documents to the new collection's docs property
        sitemap_collection.docs = all_documents

        # Register the new collection with the site object
        site.collections['sitemap_pages'] = sitemap_collection
      end
    end
  end
end