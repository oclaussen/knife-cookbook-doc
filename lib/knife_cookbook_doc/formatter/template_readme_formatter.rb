require 'erubis'

module KnifeCookbookDoc
  class TemplateReadmeFormatter < BaseFormatter
    def format
      template = File.read(config[:template_file])
      Erubis::Eruby.new(template).result(model.get_binding)
    end
  end
end
