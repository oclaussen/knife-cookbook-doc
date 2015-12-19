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
require 'knife_cookbook_doc/formatter/attributes/default_attributes_formatter'
require 'knife_cookbook_doc/formatter/definition/default_definition_formatter'
require 'knife_cookbook_doc/formatter/definition/default_parameters_formatter'
require 'knife_cookbook_doc/formatter/definition/table_parameters_formatter'
require 'knife_cookbook_doc/formatter/readme/default_license_formatter'
require 'knife_cookbook_doc/formatter/readme/default_readme_formatter'
require 'knife_cookbook_doc/formatter/readme/default_requirements_formatter'
require 'knife_cookbook_doc/formatter/readme/template_readme_formatter'
require 'knife_cookbook_doc/formatter/recipe/default_recipe_formatter'
require 'knife_cookbook_doc/formatter/resource/default_actions_formatter'
require 'knife_cookbook_doc/formatter/resource/default_resource_formatter'
require 'knife_cookbook_doc/formatter/resource/default_properties_formatter'
require 'knife_cookbook_doc/formatter/resource/table_actions_formatter'
require 'knife_cookbook_doc/formatter/resource/table_properties_formatter'

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
    definition_parameters_formatter: DefaultDefinitionParametersFormatter,
    resource_formatter: DefaultResourceFormatter,
    resource_actions_formatter: DefaultResourceActionsFormatter,
    resource_properties_formatter: DefaultResourcePropertiesFormatter,
    requirements_formatter: DefaultRequirementsFormatter,
    license_formatter: DefaultLicenseFormatter
  }


  def create_doc(cookbook_dir, config)
    config = DEFAULTS.merge(config)
    KnifeCookbookDoc.validate_configuration(config)
    model = ReadmeModel.new(cookbook_dir, config[:constraints])
    result = BaseFormatter.new(model, config).format_readme

    File.open("#{cookbook_dir}/#{config[:output_file]}", 'wb') do |f|
      result.each_line do |line|
        f.write line.gsub(/[ \t\r\n]*$/,'')
        f.write "\n"
      end
    end
  end

  def validate_configuration(config)
    # Make sure every formatter can format
    config.each do |option, value|
      next unless /\w+_formatter/ =~ option.to_s
      next if value.method_defined?(:format)
      fail "Invalid argument for option #{option}: No `format` method on #{value}."
    end

    # Use the template formatter if the user specified a template
    if is_supplied?(config, :template_file) && !is_supplied?(config, :readme_formatter)
      config[:readme_formatter] = TemplateReadmeFormatter
    end
  end

  def is_supplied?(config, key)
    config[key] != DEFAULTS[key]
  end
end
