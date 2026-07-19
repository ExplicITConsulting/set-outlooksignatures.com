class RootInclude < Liquid::Tag
  def initialize(tag_name, markup, parse_context)
    super
    @wrap_raw = false
    
    if markup.include?('|')
      parts = markup.split('|', 2)
      @meta_path = parts[0].strip
      filter_string = parts[1].to_s.strip
      
      # Check if 'raw' is requested as an option/filter
      if filter_string.split(/\s+/).include?('raw')
        @wrap_raw = true
        # Clean out 'raw' from the filter string so it doesn't break standard Liquid filters
        filter_string = filter_string.gsub(/\braw\b/, '').strip.gsub(/\s*\|\s*\z/, '')
      end
      
      @filters = filter_string.empty? ? nil : filter_string
    else
      @meta_path = markup.strip
      @filters = nil
    end
  end

  def render(context)
    raw_path = Liquid::Template.parse(@meta_path).render(context)
    clean_path = raw_path.gsub(/\A['"]|['"]\z/, '').strip

    if clean_path.empty?
      return "Error: include_absolute path is empty"
    end

    site = context.registers[:site]
    root_path = File.expand_path(site.config['source'])
    final_path = File.join(root_path, clean_path.sub(/\A\//, ''))

    if File.directory?(final_path)
      return "Error: include_absolute path points to a directory: #{clean_path}"
    elsif !File.exist?(final_path)
      return "Error: File not found: #{clean_path}"
    end

    file_content = File.read(final_path, **site.file_read_opts)

    # 1. Apply regular liquid filters if present
    if @filters
      partial_template = "{{ output | #{@filters} }}"
      context.stack do
        context['output'] = file_content
        file_content = Liquid::Template.parse(partial_template).render(context)
      end
    end

    # 2. Wrap the output in raw tags if requested
    if @wrap_raw
      file_content = "{% raw %}\n#{file_content}\n{% endraw %}"
    end

    file_content
  end
end

Liquid::Template.register_tag('include_absolute', RootInclude)