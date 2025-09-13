# _plugins/seo_remove_canonical.rb

module Jekyll
  class SeoTag
    class Drop < Jekyll::Drops::Drop
      def canonical_url
        nil
      end
    end
  end
end
