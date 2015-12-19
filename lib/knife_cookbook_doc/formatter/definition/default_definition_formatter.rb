module KnifeCookbookDoc
  module Formatter
    module Definition
      class DefaultDefinitionFormatter < Formatter::BaseFormatter
        def format
          return '' if model.top_level_descriptions.empty?
          [
            "## #{name}",
            format_main_description,
            format_parameters,
            format_other_descriptions
          ].reject(&:empty?).join("\n\n")
        end
      end
    end
  end
end
