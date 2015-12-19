module KnifeCookbookDoc
  class DefaultRequirementsFormatter < BaseFormatter
    def format
      lines = []
      lines << '## Platform:'
      if platforms.empty?
        lines << '*No platforms defined*'
      else
        lines << platforms.join("\n")
      end
      lines << '## Cookbooks:'
      if cookbooks.empty?
        lines << '*No dependencies defined*'
      else
        lines << cookbooks.join("\n")
      end
      lines.join("\n\n")
    end

    private

    def platforms
      model.platforms.map { |platform| "* #{platform}" }
    end

    def cookbooks
      dependencies + recommendations + suggestions + conflicting
    end

    def dependencies
      model.dependencies.map { |dep| "* #{dep}" }
    end

    def recommendations
      model.recommendations.map { |dep| "* #{dep} (Recommended but not required)" }
    end

    def suggestions
      model.suggestions.map { |dep| "* #{dep} (Suggested but not required)" }
    end

    def conflicting
      model.conflicting.map { |dep| "* Conflicts with #{dep}" }
    end
  end
end
