
require 'jekyll'
require 'fileutils'
require 'time'

module Jekyll
  class PolyglotSitemapGenerator
    def self.generate(site)
      return unless site && site.respond_to?(:dest)

      sitemap_path = File.join(site.dest, "sitemap.xml")
      File.open(sitemap_path, "w:utf-8") do |f|
        f.puts '<?xml version="1.0" encoding="UTF-8"?>'
        f.puts '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"'
        f.puts '        xmlns:xhtml="http://www.w3.org/1999/xhtml"'
        f.puts '        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
        f.puts '        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">'

        localized_pages = collect_localized_pages(site)

        localized_pages.each do |base_path, langs|
          default_lang = site.config['default_lang']
          default_url = langs[default_lang] ? langs[default_lang][:url] : langs.values.first[:url]
          lastmod = langs[default_lang] ? langs[default_lang][:lastmod] : langs.values.first[:lastmod]

          f.puts "  <url>"
          f.puts "    <loc>#{default_url}</loc>"
          f.puts "    <lastmod>#{lastmod}</lastmod>"
          f.puts "    <changefreq>daily</changefreq>"
          f.puts "    <priority>1.0</priority>"

          langs.each do |lang, data|
            f.puts "    <xhtml:link rel=\"alternate\" hreflang=\"#{lang}\" href=\"#{data[:url]}\" />"
          end

          f.puts "    <xhtml:link rel=\"alternate\" hreflang=\"x-default\" href=\"#{default_url}\" />"
          f.puts "  </url>"
        end

        f.puts "</urlset>"
      end
    end

    def self.collect_localized_pages(site)
      localized_pages = Hash.new { |h, k| h[k] = {} }

      Dir.glob(File.join(site.dest, "**", "*.html")).each do |path|
        relative_path = path.sub(site.dest, "")
        next if relative_path.include?("/assets/") || relative_path.include?("/sitemap.xml")

        lang = site.config['languages'].find do |l|
          relative_path.start_with?("/#{l}/")
        end || site.config['default_lang']

        clean_path = relative_path.sub(/^\/#{lang}/, "")
        clean_path = clean_path.sub(/index\.html$/, "")
        clean_path = clean_path.sub(/\.html$/, "")
        base_path = clean_path.empty? ? "/" : "/#{clean_path}"

        localized_pages[base_path][lang] = {
          path: path,
          url: site.config['url'] + relative_path,
          lastmod: File.mtime(path).iso8601
        }
      end

      localized_pages
    end
  end

  Hooks.register :site, :post_write do |site|
    PolyglotSitemapGenerator.generate(site)
  end
end
