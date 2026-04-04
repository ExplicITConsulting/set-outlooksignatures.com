module Jekyll
  module MinifyHtmlFilter
    # This filter minifies HTML strings using the logic from the 
    # jekyll-minify-html-rs project.
    # Usage: {{ content | markdownify | minify_html }}
    def minify_html(input)
      return input if input.nil? || input.empty?

      # We require the gem inside the method to ensure it's loaded 
      # even if the plugin load order is wonky.
      begin
        require 'minify_html'
      rescue LoadError
        Jekyll.logger.error "MinifyHTML Error:", "Gem 'minify_html' not found in your environment."
        return input
      end

      # Options based on the minify_html gem documentation (v0.11.2).
      options = {
        minify_css: true,
        minify_js: true,
        remove_comments: true,
        collapse_whitespace: true,
        keep_spaces_between_attributes: true
      }
      
      begin
        # Some versions/bindings use MinifyHtml, others use MinifyHTML.
        # We check for both to be safe.
        if defined?(::MinifyHtml)
          ::MinifyHtml.minify(input, options)
        elsif defined?(::MinifyHTML)
          ::MinifyHTML.minify(input, options)
        else
          Jekyll.logger.error "MinifyHTML Error:", "Constant MinifyHtml/MinifyHTML not found after require."
          input
        end
      rescue => e
        Jekyll.logger.error "MinifyHTML Error:", e.message
        input # Fallback to original input if minification fails
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyHtmlFilter)