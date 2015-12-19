module KnifeCookbookDoc
  class DefaultResourceFormatter < BaseFormatter
    def format
      [
        "## #{model.name}",
        format_main_description,
        format_resource_actions,
        format_resource_properties,
        format_other_descriptions
      ].reject(&:empty?).join("\n\n")
    end
  end
end
