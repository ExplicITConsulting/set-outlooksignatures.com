# _plugins/sitemap_index_generator.rb
require 'jekyll'
require 'fileutils'
require 'time'
require 'nokogiri'

module Jekyll
  class SitemapIndexGenerator
    def self.generate(site)
      return unless site && site.respond_to?(:dest)

      languages = site.config['languages']
      base_url = site.config['url']
      default_lang = site.config['default_lang']

      sitemap_path = File.join(site.dest, "sitemap.xml")

      File.open(sitemap_path, "w:utf-8") do |f|
        doc = Nokogiri::XML::Builder.new do |xml|
          xml.sitemapindex('xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9") do
            languages.each do |lang|
              sitemap_loc = (lang == default_lang) ?
                            "#{base_url}/sitemap-#{lang}.xml" :
                            "#{base_url}/#{lang}/sitemap-#{lang}.xml"

              xml.sitemap do
                xml.loc sitemap_loc
                xml.lastmod Time.now.iso8601
              end
            end
          end
        end
        f.write(doc.to_xml)
      end
    end
  end

  # This hook runs only once, after all language builds are complete.
  Jekyll::Hooks.register :polyglot, :post_write do |site|
    Jekyll::SitemapIndexGenerator.generate(site)
  end
end