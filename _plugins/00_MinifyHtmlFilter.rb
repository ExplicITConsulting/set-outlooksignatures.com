require 'minify_html'

module Jekyll
  module MinifyHtmlFilter
    # This filter minifies HTML strings using the logic from the 
    # jekyll-minify-html-rs project.
    # Usage: {{ content | markdownify | minify_html }}
    def minify_html(input)
      return input if input.nil? || input.empty?

      # Options based on the minify_html gem documentation (v0.11.2).
      # All Cfg fields are available; if omitted, they default to false.
      options = {
        minify_css: true,
        minify_js: true,
        remove_comments: true,
        collapse_whitespace: true,
        keep_spaces_between_attributes: true
      }
      
      begin
        # Attempt to call the minify method on the MinifyHtml module.
        # We use the global constant directly.
        if defined?(::MinifyHtml)
          ::MinifyHtml.minify(input, options)
        else
          # If the constant is still missing, log it and return input
          Jekyll.logger.error "MinifyHTML Error:", "Constant MinifyHtml not found. Check if the gem is in your Gemfile."
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