module KnifeCookbookDoc
  class DefaultRecipeFormatter < BaseFormatter
    def format
      return '' if model.top_level_descriptions.empty?

      lines = []
      lines << "## #{model.name}"

      unless model.top_level_description('main').empty?
        lines << model.top_level_description('main').strip
      end

      model.top_level_descriptions.keys.reject{ |k| k == 'main' }.each do |key|
        lines << "### #{key}"
        lines << model.top_level_description(key).strip
      end

      lines.join "\n\n"
    end
  end
end
