require 'erubis'

module KnifeCookbookDoc
  module Formatter
    module Readme
      class TemplateReadmeFormatter < Formatter::BaseFormatter
        def format
          template = File.read(config[:template_file])
          Erubis::Eruby.new(template).result(model.get_binding)
        end
      end
    end
  end
end
