module KnifeCookbookDoc
  module Formatter
    module Resource
      class TablePropertiesFormatter < Formatter::BaseFormatter
        def format
          return '' if model.attributes.empty?
          lines = []

          lines << '|Property|Description|Default|'
          lines << '|--------|-----------|-------|'
          lines += model.attributes.map { |a| format_attribute a }

          lines.join "\n"
        end

        private

        def format_attribute(attribute)
          "|#{attribute}|#{model.attribute_description(attribute)}|`#{model.attribute_default_value(attribute).inspect}`|"
        end
      end
    end
  end
end
