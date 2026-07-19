class RootInclude < Liquid::Tag
  # The '?' makes the pipe and everything after it completely optional
  SYNTAX = /(.*?)(?:\s*\|\s*(.*))?/o

  def initialize(tag_name, markup, parse_context)
    super
    if markup =~ SYNTAX
      @meta_path = $1.strip
      # Only capture the filter if it's present and not empty
      @filters = $2.to_s.strip.empty? ? nil : $2.strip
    else
      @meta_path = markup.strip
      @filters = nil
    end
  end

  def render(context)
    raw_path = Liquid::Template.parse(@meta_path).render(context)
    clean_path = raw_path.gsub(/\A['"]|['"]\z/, '')

    site = context.registers[:site]
    root_path = File.expand_path(site.config['source'])
    final_path = File.join(root_path, clean_path.sub(/\A\//, ''))

    unless File.exist?(final_path)
      return "File not found: #{clean_path}"
    end

    file_content = File.read(final_path, **site.file_read_opts)

    # If no filters were provided, just return the raw file content safely
    if @filters
      partial_template = "{{ output | #{@filters} }}"
      context.stack do
        context['output'] = file_content
        file_content = Liquid::Template.parse(partial_template).render(context)
      end
    end

    file_content
  end
end

Liquid::Template.register_tag('include_relative', RootInclude)