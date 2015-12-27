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
    formatters: []
  }

  MAGIC_FORMATTER_LOOKUP = {
    readme: {
      default: Formatter::Readme::DefaultReadmeFormatter,
      template: Formatter::Readme::TemplateReadmeFormatter
    },
    attributes: {
      default: Formatter::Attributes::DefaultAttributesFormatter
    },
    recipe: {
      default: Formatter::Recipe::DefaultRecipeFormatter
    },
    definition: {
      default: Formatter::Definition::DefaultDefinitionFormatter
    },
    parameters: {
      default: Formatter::Definition::DefaultParametersFormatter,
      table: Formatter::Definition::TableParametersFormatter
    },
    resource: {
      default: Formatter::Resource::DefaultResourceFormatter
    },
    actions: {
      default: Formatter::Resource::DefaultActionsFormatter,
      table: Formatter::Resource::TableActionsFormatter
    },
    properties: {
      default: Formatter::Resource::DefaultPropertiesFormatter,
      table: Formatter::Resource::TablePropertiesFormatter
    },
    requirements: {
      default: Formatter::Readme::DefaultRequirementsFormatter
    },
    license: {
      default: Formatter::Readme::DefaultLicenseFormatter
    }
  }

  def create_doc(cookbook_dir, config)
    config = DEFAULTS.merge(config)
    KnifeCookbookDoc.validate_configuration(config)
    model = ReadmeModel.new(cookbook_dir, config[:constraints])
    result = Formatter::BaseFormatter.new(model, config).format_readme

    File.open("#{cookbook_dir}/#{config[:output_file]}", 'wb') do |f|
      result.each_line do |line|
        f.write line.gsub(/[ \t\r\n]*$/, '')
        f.write "\n"
      end
    end
  end

  def validate_configuration(config)
    # Parse formatters from command line
    config[:formatters].each do |type, value|
      config["#{type.downcase}_formatter".to_sym] = value
    end

    # Make sure a formatter for every type exists
    MAGIC_FORMATTER_LOOKUP.each do |type, _|
      option_name = "#{type}_formatter".to_sym
      config[option_name] = :default unless config.key?(option_name)
    end

    # Make sure every formatter can format
    config.each do |option, value|
      config[option] = validate_formatter(option, value)
    end

    # Use the template formatter if the user specified a template
    if supplied?(config, :template_file) && !supplied?(config, :readme_formatter)
      config[:readme_formatter] = Formatter::Readme::TemplateReadmeFormatter
    end
  end

  def validate_formatter(option, value)
    return value unless /\w+_formatter/ =~ option.to_s
    formatter = value
    unless formatter.is_a?(Class)
      begin
        formatter = value.to_s.split('::').reduce(Module, :const_get)
      rescue NameError
        type = /(\w+)_formatter/.match(option)[1]
        formatter = MAGIC_FORMATTER_LOOKUP[type.to_sym][formatter.to_sym]
      rescue NoMethodError
        fail "Could not find formatter #{value} for #{type}."
      end
    end
    return formatter if formatter.method_defined?(:format)
    fail "Invalid argument for option #{option}: No `format` method on #{value}."
  end

  def supplied?(config, key)
    config[key] != DEFAULTS[key]
  end
end
