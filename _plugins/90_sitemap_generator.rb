require 'jekyll'
require 'fileutils'
require 'time'

module Jekyll
  class PolyglotSitemapGenerator
    def self.generate(site)
      sitemap_path = File.join(site.dest, "sitemap.xml")
      File.open(sitemap_path, "w:utf-8") do |f|
        f.puts '<?xml version="1.0" encoding="UTF-8"?>'
        f.puts '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"'
        f.puts '        xmlns:xhtml="http://www.w3.org/1999/xhtml"'
        f.puts '        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
        f.puts '        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">'

        items = site.posts.docs + site.pages
        items.each do |item|
          next if item.data['sitemap'] == false
          next if item.url == '/redirects.json' || item.url == '/robots.txt' || item.url == '/assets/css/app.css'

          lastmod = item.data['last_modified_at'] || item.data['date'] || site.time
          url = site.config['url'] + item.url

          f.puts "  <url>"
          f.puts "    <loc>#{url}</loc>"
          f.puts "    <lastmod>#{lastmod.iso8601}</lastmod>"
          f.puts "    <changefreq>daily</changefreq>"
          f.puts "    <priority>1.0</priority>"

          base_path = strip_lang_prefix(item.url, site.config['languages'], site.config['default_lang'])

          site.config['languages'].each do |lang|
            localized_url = lang == site.config['default_lang'] ? base_path : "/#{lang}#{base_path}"
            if items.any? { |i| i.url == localized_url }
              f.puts "    <xhtml:link rel=\"alternate\" hreflang=\"#{lang}\" href=\"#{site.config['url']}#{localized_url}\" />"
            end
          end
          f.puts "    <xhtml:link rel=\"alternate\" hreflang=\"x-default\" href=\"#{site.config['url']}#{base_path}\" />"
          f.puts "  </url>"
        end

        f.puts "</urlset>"
      end
    end


    def self.strip_lang_prefix(url, languages, default_lang)
      languages.each do |lang|
        next if lang == default_lang
        prefix = "/#{lang}/"
        return url.sub(prefix, "/") if url.start_with?(prefix)
      end
      url
    end
  end


  Jekyll::Hooks.register :polyglot, :post_write do |site|
    PolyglotSitemapGenerator.generate(site)
  end

end
