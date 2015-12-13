module KnifeCookbookDoc
  class DefaultDefinitionFormatter
    def format(model)
      return '' if model.top_level_descriptions.empty?

      lines = []
      lines << "## #{name}"

      unless model.top_level_description('main').empty?
        lines << model.top_level_description('main').strip
      end

      unless model.params.empty?
        lines << '### Parameters'

        model.params.each do |param, data|
          line = "- #{param}: #{data['descr']}."
          line += "Defaults to: #{data['default']}" unless data['default'].nil?
          lines << line
        end
      end

      model.top_level_descriptions.keys.reject{ |k| k == 'main' }.each do |key|
        lines << "### #{key}"
        lines << model.top_level_description(key).strip
      end

      lines.join "\n\n"
    end
  end
end
