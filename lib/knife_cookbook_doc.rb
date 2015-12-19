require 'chef/cookbook/metadata'

require 'knife_cookbook_doc/version'
require 'knife_cookbook_doc/documenting_lwrp_base'
require 'knife_cookbook_doc/base_model'
require 'knife_cookbook_doc/definitions_model'
require 'knife_cookbook_doc/readme_model'
require 'knife_cookbook_doc/recipe_model'
require 'knife_cookbook_doc/resource_model'
require 'knife_cookbook_doc/attributes_model'
require 'knife_cookbook_doc/formatter/base_formatter'
require 'knife_cookbook_doc/formatter/default_readme_formatter'
require 'knife_cookbook_doc/formatter/template_readme_formatter'
require 'knife_cookbook_doc/formatter/default_attributes_formatter'
require 'knife_cookbook_doc/formatter/default_recipe_formatter'
require 'knife_cookbook_doc/formatter/default_definition_formatter'
require 'knife_cookbook_doc/formatter/default_resource_formatter'
require 'knife_cookbook_doc/formatter/default_requirements_formatter'
require 'knife_cookbook_doc/formatter/default_license_formatter'

module KnifeCookbookDoc
  module_function

  DEFAULTS = {
    cookbook_dir: './',
    constraints: true,
    output_file: 'README.md',
    template_file: Pathname.new("#{File.dirname(__FILE__)}/chef/knife/README.md.erb").realpath,

    readme_formatter: DefaultReadmeFormatter,
    attributes_formatter: DefaultAttributesFormatter,
    recipe_formatter: DefaultRecipeFormatter,
    definition_formatter: DefaultDefinitionFormatter,
    resource_formatter: DefaultResourceFormatter,
    requirements_formatter: DefaultRequirementsFormatter,
    license_formatter: DefaultLicenseFormatter
  }


  def create_doc(cookbook_dir, config)
    config = DEFAULTS.merge(config)
    model = ReadmeModel.new(cookbook_dir, config[:constraints])
    result = BaseFormatter.new(model, config).format_readme

    File.open("#{cookbook_dir}/#{config[:output_file]}", 'wb') do |f|
      result.each_line do |line|
        f.write line.gsub(/[ \t\r\n]*$/,'')
        f.write "\n"
      end
    end
  end
end
