module KnifeCookbookDoc
  class DefaultAttributesFormatter < BaseFormatter
    def format
      model.attributes.map do |name, description, default, choice|
        line = "* `#{name}` - #{description}"
        line += '.' unless description.nil? || description.strip.end_with?('.')
        line += " Available options: `#{choice.map(&:inspect).join('`, `')}`." unless choice.empty?
        line += " Defaults to `#{default}`."
      end.join "\n"
    end
  end
end
