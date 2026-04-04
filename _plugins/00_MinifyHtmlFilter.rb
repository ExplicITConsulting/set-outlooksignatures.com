module Jekyll
  module MinifyHtmlFilter
    # This filter minifies HTML strings using the 'minify_html' gem (Rust-based).
    # Usage: {{ content | markdownify | minify_html }}
    def minify_html(input)
      return input if input.nil? || input.empty?

      # Lazy-load the gem to ensure it's available after Jekyll's plugin initialization
      begin
        require 'minify_html' unless defined?(::MinifyHtml)
      rescue LoadError
        Jekyll.logger.error "MinifyHTML Error:", "Gem 'minify_html' not found. Ensure it is in your Gemfile."
        return input
      end

      # Options according to https://www.rubydoc.info/gems/minify_html/0.11.2
      options = {
        minify_css: true,
        minify_js: true,
        remove_comments: true,
        collapse_whitespace: true,
        keep_spaces_between_attributes: true
      }

      begin
        # Use Object.const_get to find the constant in the global scope
        # This is more robust when the gem is loaded via the Jekyll 'plugins' config
        klass = Object.const_get(:MinifyHtml)
        klass.minify(input, options)
      rescue NameError
        Jekyll.logger.error "MinifyHTML Error:", "Constant MinifyHtml is uninitialized. Check gem loading."
        input
      rescue => e
        Jekyll.logger.error "MinifyHTML Error:", e.message
        input
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyHtmlFilter)