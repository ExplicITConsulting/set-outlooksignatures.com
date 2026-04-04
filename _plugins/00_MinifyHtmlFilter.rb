require 'html_minify'

module Jekyll
  module MinifyHtmlFilter
    # This filter minifies HTML strings using the logic from the 
    # html-minify-rs project.
    # Usage: {{ content | markdownify | minify_html }}
    def minify_html(input)
      return input if input.nil? || input.empty?

      # Default configuration for the minifier
      # Adjust these options based on your specific requirements
      options = {
        minify_css: true,
        minify_js: true,
        remove_comments: true,
        remove_empty_attributes: false,
        collapse_whitespace: true
      }

      begin
        # Use the HtmlMinify gem (the Ruby binding for the Rust minifier)
        HtmlMinify.minify(input, options)
      rescue => e
        Jekyll.logger.error "MinifyHTML Error:", e.message
        input # Fallback to original input if minification fails
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyHtmlFilter)