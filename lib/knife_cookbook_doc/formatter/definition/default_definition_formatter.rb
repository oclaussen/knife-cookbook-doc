module KnifeCookbookDoc
  class DefaultDefinitionFormatter < BaseFormatter
    def format
      return '' if model.top_level_descriptions.empty?

      lines = []
      lines << "## #{name}"

      unless model.top_level_description('main').empty?
        lines << model.top_level_description('main').strip
      end

      lines << format_definition_parameters

      model.top_level_descriptions.keys.reject{ |k| k == 'main' }.each do |key|
        lines << "### #{key}"
        lines << model.top_level_description(key).strip
      end

      lines.join "\n\n"
    end
  end
end
