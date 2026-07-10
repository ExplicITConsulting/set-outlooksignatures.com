module Jekyll
  module LiquidifyFilter
    def liquidify(input)
      Liquid::Template.parse(input).render(@context)
    end
  end
end

Liquid::Template.register_filter(Jekyll::LiquidifyFilter)