# _plugins/sitemap_generator.rb
module Jekyll
  class SitemapGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Get all documents from pages and posts
      all_documents = site.pages.concat(site.posts)

      # Check if Polyglot is enabled
      if site.config['languages']
        # If Polyglot is active, get all documents from all languages
        all_documents = site.posts.docs.concat(site.pages.docs)
      end

      # Add the documents to the custom collection
      site.collections['sitemap_pages'].docs = all_documents
    end
  end
end