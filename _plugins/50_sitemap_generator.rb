# _plugins/50_sitemap_generator.rb


module Jekyll
  class SitemapGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Get all documents from pages and posts
      # The .to_a method is used to ensure we are working with arrays
      # and not internal Jekyll collections, which can have different behaviors.
      all_documents = site.posts.to_a.concat(site.pages.to_a)

      # Add the documents to the custom collection
      site.collections['sitemap_pages'].docs = all_documents
    end
  end
end