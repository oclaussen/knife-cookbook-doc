module KnifeCookbookDoc
  module Formatter
    module Definition
      class DefaultParametersFormatter < Formatter::BaseFormatter
        def format
          return '' if model.params.empty?

          lines = []
          lines << "### Parameters\n"

          model.params.each do |param, data|
            line = "- #{param}: #{data['descr']}."
            line += "Defaults to: #{data['default']}" unless data['default'].nil?
            lines << line
          end

          lines.join "\n"
        end
      end
    end
  end
end
