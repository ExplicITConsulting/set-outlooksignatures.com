class RootInclude < Liquid::Tag
  def initialize(tag_name, markup, parse_context)
    super
    
    if markup.include?('|')
      parts = markup.split('|', 2)
      @meta_path = parts[0].strip
      filter_string = parts[1].to_s.strip
      
     
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

    # Apply regular liquid filters if present
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

Liquid::Template.register_tag('include_absolute', RootInclude)