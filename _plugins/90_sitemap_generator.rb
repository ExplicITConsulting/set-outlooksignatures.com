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

        items = site.posts.docs + site.pages

        # Include localized static HTML files
        localized_htmls = site.static_files.select do |f|
          f.extname == ".html" && f.path.include?(site.dest)
        end

        localized_htmls.each do |file|
          # Skip if already included in site.pages
          next if items.any? { |i| i.url == file.relative_path }

          # Create a fake page-like object
          item = OpenStruct.new(
            url: "/" + file.relative_path.sub(/^#{site.dest}\//, ""),
            data: { 'date' => File.mtime(file.path), 'sitemap' => true }
          )

          items << item
        end

        items.each do |item|
          next if item.data['sitemap'] == false
          next if ['/redirects.json', '/robots.txt', '/assets/css/app.css'].include?(item.url)

          lastmod = item.data['last_modified_at'] || item.data['date'] || site.time
          url = site.config['url'].to_s + item.url
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

  Hooks.register :site, :post_write do |site|
    PolyglotSitemapGenerator.generate(site)
  end
end
