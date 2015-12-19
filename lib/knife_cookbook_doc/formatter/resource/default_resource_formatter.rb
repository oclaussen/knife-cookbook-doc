module KnifeCookbookDoc
  module Formatter
    module Resource
      class DefaultResourceFormatter < Formatter::BaseFormatter
        def format
          [
            "## #{model.name}",
            format_main_description,
            format_actions,
            format_properties,
            format_other_descriptions
          ].reject(&:empty?).join("\n\n")
        end
      end
    end
  end
end
