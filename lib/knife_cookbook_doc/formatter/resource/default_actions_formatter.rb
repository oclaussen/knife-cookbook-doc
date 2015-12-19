module KnifeCookbookDoc
  module Formatter
    module Resource
      class DefaultActionsFormatter < Formatter::BaseFormatter
        def format
          return '' if model.actions.empty?
          lines = []

          lines << "### Actions\n"
          lines << "- Default actions: [#{model.default_action.join ', '}]" if format_defaults?

          model.actions.map do |action|
            line = "- #{action}: #{model.action_description(action)}"
            line += ' Default action.' if default?(action)
            lines << line
          end

          lines.join "\n"
        end

        private

        def format_defaults?
          model.default_action.is_a?(Array)
        end

        def default?(action)
          return false if model.default_action.is_a?(Array)
          model.default_action == action
        end
      end
    end
  end
end
