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
      languages = site.config['languages']
      base_url = site.config['url']
      current_lang = site.data['lang'] || default_lang

      urls = []
      (site.pages + site.documents).each do |document|
        # Use a consistent, reliable method to filter URLs.
        if current_lang == default_lang
          # For the default language, include only URLs without a language prefix.
          next if languages.any? { |l| document.url.start_with?("/#{l}/") }
        else
          # For other languages, include only URLs with the correct language prefix.
          next unless document.url.start_with?("/#{current_lang}/")
        end

        # Use document.data to access the front matter.
        next if document.data['sitemap'] == false
        next if document.url.nil? || document.url.start_with?('/assets/') || document.url.include?('/sitemap') || document.url.include?('404.html') || document.url.include?('redirects.json')

        lastmod = (document.last_modified_at rescue Time.now).iso8601
        url = base_url + document.url

        urls << { url: url, lastmod: lastmod }
      end

      sitemap_filename = "sitemap-#{current_lang}.xml"
      sitemap_path = File.join(site.dest, sitemap_filename)

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

  Jekyll::Hooks.register :site, :post_write do |site|
    Jekyll::LanguageSitemapGenerator.generate(site)
  end
end