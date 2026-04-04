module Jekyll
  module MinifyHtmlFilter
    # This filter minifies HTML strings using the logic from the 
    # jekyll-minify-html-rs project.
    # Usage: {{ content | markdownify | minify_html }}
    def minify_html(input)
      return input if input.nil? || input.empty?

      # Ensure the gem is required
      begin
        require 'minify_html'
      rescue LoadError
        Jekyll.logger.error "MinifyHTML Error:", "Gem 'minify_html' not found in your environment."
        return input
      end

      # Configuration options for v0.11.2
      options = {
        minify_css: true,
        minify_js: true,
        remove_comments: true,
        collapse_whitespace: true,
        keep_spaces_between_attributes: true
      }
      
      begin
        # Use Object.const_get to bypass potential nesting issues in Jekyll's loader
        # We try the standard documented naming first
        klass = if Object.const_defined?(:MinifyHtml)
                  Object.const_get(:MinifyHtml)
                elsif Object.const_defined?(:MinifyHTML)
                  Object.const_get(:MinifyHTML)
                else
                  nil
                end

        if klass && klass.respond_to?(:minify)
          klass.minify(input, options)
        else
          # Debugging block: let's see what is actually there
          available = Object.constants.select { |c| c.to_s.downcase.include?('minify') }
          Jekyll.logger.error "MinifyHTML Error:", "Constant not found. Similar constants available: #{available.join(', ')}"
          input
        end
      rescue => e
        Jekyll.logger.error "MinifyHTML Error:", e.message
        input
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::MinifyHtmlFilter)