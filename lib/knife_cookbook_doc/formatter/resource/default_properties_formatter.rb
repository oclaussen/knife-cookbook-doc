module KnifeCookbookDoc
  class DefaultResourcePropertiesFormatter < BaseFormatter
    def format
      return '' if model.attributes.empty?
      lines = []

      lines << "### Attribute Parameters\n"
      lines += model.attributes.map { |a| format_attribute a }

      lines.join "\n"
    end

    private

    def format_attribute(attribute)
      "- #{attribute}: #{model.attribute_description(attribute)}#{format_default(attribute)}"
    end

    def format_default(attribute)
      return '' unless model.attribute_has_default_value?(attribute)
      " Defaults to <code>#{model.attribute_default_value(attribute).inspect}</code>."
    end
  end
end
