# _plugins/language_sitemap_generator.rb
require 'jekyll'
require 'fileutils'
require 'time'
require 'nokogiri'

module Jekyll
  class LanguageSitemapGenerator
    def self.generate(site)
      return unless site && site.respond_to?(:dest)

      default_lang = site.config['default_lang']
      base_url = site.config['url']
      current_lang = site.data['lang'] || default_lang

      # Collect all pages and documents for the current language's build.
      urls = []
      (site.pages + site.documents).each do |document|
        next if document.data['sitemap'] == false
        next if document.url.nil? || document.url.start_with?('/assets/') || document.url.include?('/sitemap') || document.url.include?('404.html')

        lastmod = (document.last_modified_at rescue Time.now).iso8601
        url = base_url + document.url

        urls << { url: url, lastmod: lastmod }
      end

      # Determine the sitemap filename and path.
      sitemap_filename = "sitemap-#{current_lang}.xml"
      sitemap_path = (current_lang == default_lang) ?
                     File.join(site.dest, sitemap_filename) :
                     File.join(site.dest, current_lang, sitemap_filename)

      # Ensure the directory exists.
      FileUtils.mkdir_p(File.dirname(sitemap_path))

      # Generate the XML content.
      File.open(sitemap_path, "w:utf-8") do |f|
        doc = Nokogiri::XML::Builder.new do |xml|
          xml.urlset('xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9") do
            urls.each do |data|
              xml.url do
                xml.loc data[:url]
                xml.lastmod data[:lastmod]
              end
            end
          end
        end
        f.write(doc.to_xml)
      end
    end
  end

  # This hook runs for each language build, correctly isolated by Polyglot.
  Jekyll::Hooks.register :site, :post_write do |site|
    Jekyll::LanguageSitemapGenerator.generate(site)
  end
end