module KnifeCookbookDoc
  class TableDefinitionParametersFormatter < BaseFormatter
    def format
      return '' if model.params.empty?
      lines = []

      lines << '|Parameter|Description|Default|'
      lines << '|---------|-----------|-------|'
      lines += model.params.map do |param, data|
        "|#{param}|#{data['descr']}|#{data['default'] || ''}|"
      end

      lines.join "\n"
    end
  end
end
