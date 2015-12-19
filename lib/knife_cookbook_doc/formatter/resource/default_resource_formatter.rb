module KnifeCookbookDoc
  class DefaultResourceFormatter < BaseFormatter
    def format
      lines = []
      lines << "## #{model.name}"

      unless model.top_level_description('main').empty?
        lines << model.top_level_description('main').strip
      end

      lines << format_resource_actions
      lines << format_resource_properties

      model.top_level_descriptions.keys.reject{ |k| k == 'main' }.each do |key|
        lines << "### #{key}"
        lines << model.top_level_description(key).strip
      end

      lines.join "\n\n"
    end
  end
end
