class RootInclude < Liquid::Tag
  def initialize(tag_name, markup, parse_context)
    super
    # Split by the first pipe character to cleanly separate path from filters
    if markup.include?('|')
      parts = markup.split('|', 2)
      @meta_path = parts[0].strip
      @filters = parts[1].to_s.strip.empty? ? nil : parts[1].strip
    else
      @meta_path = markup.strip
      @filters = nil
    end
  end

  def render(context)
    # Render the path in case there are liquid variables inside it
    raw_path = Liquid::Template.parse(@meta_path).render(context)
    
    # Strip any leading/trailing quotes from the path string
    clean_path = raw_path.gsub(/\A['"]|['"]\z/, '').strip

    # Safety check: if the path resolves to nothing, stop here
    if clean_path.empty?
      return "Error: include_relative path is empty"
    end

    site = context.registers[:site]
    root_path = File.expand_path(site.config['source'])
    
    # Remove any leading slash to ensure File.join interprets it relative to site root
    final_path = File.join(root_path, clean_path.sub(/\A\//, ''))

    # Safety check: check existence and make sure it's not a directory
    if File.directory?(final_path)
      return "Error: include_relative path points to a directory: #{clean_path}"
    elsif !File.exist?(final_path)
      return "Error: File not found: #{clean_path}"
    end

    # Read the file safely
    file_content = File.read(final_path, **site.file_read_opts)

    # Apply the liquid filters if they are present
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