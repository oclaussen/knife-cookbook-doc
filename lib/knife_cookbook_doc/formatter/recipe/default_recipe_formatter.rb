module KnifeCookbookDoc
  module Formatter
    module Recipe
      class DefaultRecipeFormatter < Formatter::BaseFormatter
        def format
          return '' if model.top_level_descriptions.empty?
          [
            "## #{model.name}",
            format_main_description,
            format_other_descriptions
          ].reject(&:empty?).join("\n\n")
        end
      end
    end
  end
end
