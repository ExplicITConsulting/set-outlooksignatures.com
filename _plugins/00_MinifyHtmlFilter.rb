require 'minify_html'

module Jekyll
  module MinifyHtmlFilter
    # This filter minifies HTML strings using the logic from the 
    # jekyll-minify-html-rs project.
    # Usage: {{ content | markdownify | minify_html }}
    def minify_html(input)
      return input if input.nil? || input.empty?

      # Options based on the minify_html gem documentation.
      # All Cfg fields are available; if omitted, they default to false.
      options = {
        :minify_css => true,
        :minify_js => true,
        :remove_comments => true,
        :collapse_whitespace => true,
        :keep_spaces_between_attributes => true
      }
      
      begin
        # According to rubydoc.info/gems/minify_html, the method is 
        # MinifyHtml.minify(string, options_hash)
        ::MinifyHtml.minify(input, options)
      rescue => e
        Jekyll.logger.error "MinifyHTML Error:", e.message
        input # Fallback to original input if minification fails
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyHtmlFilter)