module KnifeCookbookDoc
  class DefaultResourceFormatter
    def format(model)
      lines = []
      lines << "## #{model.name}"

      unless model.top_level_description('main').empty?
        lines << model.top_level_description('main').strip
      end

      unless model.actions.empty?
        lines << '### Actions'
        lines << "- Default actions: [#{model.default_action.join ', '}]" if model.default_action.is_a?(Array)
        lines << model.actions.map do |action|
          line = "- #{action}: #{model.action_description(action)}"
          if !model.default_action.is_a?(Array) && model.default_action == action
            line += ' Default action.'
          end
          line
        end.join("\n")
      end

      unless model.attributes.empty?
        lines << '### Attribute Parameters'
        lines << model.attributes.map do |attribute|
          line = "- #{attribute}: #{model.attribute_description(attribute)}"
          if model.attribute_has_default_value?(attribute)
            line += " Defaults to <code>#{model.attribute_default_value(attribute).inspect}</code>."
          end
          line
        end.join("\n")
      end

      model.top_level_descriptions.keys.reject{ |k| k == 'main' }.each do |key|
        lines << "### #{key}"
        lines << model.top_level_description(key).strip
      end

      lines.join "\n\n"
    end
  end
end
