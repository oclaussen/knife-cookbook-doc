module KnifeCookbookDoc
  class TableResourceActionsFormatter < BaseFormatter
    def format
      return '' if model.actions.empty?
      lines = []

      lines << '|Action|Description|Default|'
      lines << '|------|-----------|-------|'
      lines += model.actions.map do |action|
        "|#{action}|#{model.action_description(action)}|#{is_default?(action)}|"
      end

      lines.join "\n"
    end

    private

    def is_default?(action)
      return false if model.default_action.is_a?(Array)
      model.default_action == action
    end
  end
end
