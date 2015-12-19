module KnifeCookbookDoc
  module Formatter
    module Readme
      class DefaultReadmeFormatter < Formatter::BaseFormatter
        def format
          [
            description,
            requirements,
            attributes,
            recipes,
            resources,
            license
          ].join "\n\n"
        end

        private

        def description
          "# Description\n\n" + (model.fragments['overview'] || model.description).strip
        end

        def requirements
          "# Requirements\n\n" + format_requirements(model)
        end

        def license
          return model.fragments['credit'] unless model.fragments['credit'].nil?
          "# License and Maintainer\n\n" + format_license(model)
        end

        def attributes
          return "# Attributes\n\n*No attributes defined" if model.attributes.empty?
          "# Attributes\n\n" + format_attributes(model)
        end

        def recipes
          return "# Recipes\n\n*No recipes defined*" if model.recipes.empty?
          [
            '# Recipes',
            format_toc(model.recipes),
            model.recipes.map { |r| format_recipe r }
          ].flatten.join "\n\n"
        end

        def definitions
          return '' if model.definitions.empty?
          [
            '# Definitions',
            format_toc(model.definitions),
            model.definitions.map { |d| format_definition d }
          ].flatten.join "\n\n"
        end

        def resources
          return '' if model.resources.empty?
          [
            '# Resources',
            format_toc(model.resources),
            model.resources.map { |r| format_resource r }
          ].flatten.join "\n\n"
        end

        def fragments
          model.fragments.keys.reject { |k| k == 'overview' || k == 'credit' }.map { |key| model.fragments[key].strip }.join "\n\n"
        end

        def format_toc(items)
          items.map do |item|
            line = "* [#{item.name}](##{item.name.to_s.delete(':')})"
            line += " - #{item.short_description}" unless item.short_description.empty?
            line
          end.join "\n"
        end
      end
    end
  end
end
