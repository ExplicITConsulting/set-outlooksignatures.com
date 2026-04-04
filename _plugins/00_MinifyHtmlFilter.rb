require 'minify_html'

module Jekyll
  module MinifyHtmlFilter
    # This filter minifies HTML strings using the logic from the 
    # jekyll-minify-html-rs project.
    # Usage: {{ content | markdownify | minify_html }}
    def minify_html(input)
      return input if input.nil? || input.empty?

      # Options based on the jekyll-minify-html-rs gem's expected hash structure
      options = {
        :keep_ssi_comments => false,
        :minify_css => true,
        :minify_js => true,
        :remove_comments => true,
        :collapse_whitespace => true
      }
      
      begin
        # Call the global minify_html method provided by the gem directly.
        # We remove the '::' prefix which was causing the SyntaxError.
        # Ruby will find the global method if it's not defined in the current module.
        send(:minify_html, input, options)
      rescue => e
        Jekyll.logger.error "MinifyHTML Error:", e.message
        input # Fallback to original input if minification fails
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyHtmlFilter)