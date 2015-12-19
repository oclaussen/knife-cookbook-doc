module KnifeCookbookDoc
  class DefaultDefinitionFormatter < BaseFormatter
    def format
      return '' if model.top_level_descriptions.empty?
      [
        "## #{name}",
        format_main_description,
        format_definition_parameters,
        format_other_descriptions
      ].reject(&:empty?).join("\n\n")
    end
  end
end
