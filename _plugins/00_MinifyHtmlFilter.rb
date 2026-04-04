require 'minify_html'

module Jekyll
  module MinifyHtmlFilter
    # This filter minifies HTML strings using the logic from the 
    # jekyll-minify-html-rs project (using the minify-html engine).
    # Usage: {{ content | markdownify | minify_html }}
    def minify_html(input)
      return input if input.nil? || input.empty?

      # Configuration for the minify-html-rs engine
      # We use ::MinifyHtml to ensure we reference the global namespace
      cfg = ::MinifyHtml::Config.new
      cfg.minify_css = true
      cfg.minify_js = true
      cfg.remove_comments = true
      cfg.collapse_whitespace = true
      
      begin
        # Use the correct method signature for the minify-html-rs ruby gem
        ::MinifyHtml.minify(input, cfg)
      rescue => e
        Jekyll.logger.error "MinifyHTML Error:", e.message
        input # Fallback to original input if minification fails
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyHtmlFilter)