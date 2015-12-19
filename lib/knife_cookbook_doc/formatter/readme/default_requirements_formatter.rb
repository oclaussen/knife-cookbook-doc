module KnifeCookbookDoc
  module Formatter
    module Readme
      class DefaultRequirementsFormatter < Formatter::BaseFormatter
        def format
          [
            '## Platform:',
            platforms.empty? ? '*No platforms defined*' : platforms.join("\n"),
            '## Cookbooks:',
            cookbooks.empty? ? '*No dependencies defined*' : cookbooks.join("\n")
          ].join("\n\n")
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
  end
end
