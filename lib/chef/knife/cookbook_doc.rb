require 'chef/knife'
require 'pathname'

module KnifeCookbookDoc
  class CookbookDoc < Chef::Knife
    deps do
      require 'chef/cookbook/metadata'
      require 'knife_cookbook_doc/documenting_lwrp_base'
      require 'knife_cookbook_doc/base_model'
      require 'knife_cookbook_doc/definitions_model'
      require 'knife_cookbook_doc/readme_model'
      require 'knife_cookbook_doc/recipe_model'
      require 'knife_cookbook_doc/resource_model'
      require 'knife_cookbook_doc/attributes_model'
      require 'knife_cookbook_doc/formatter/default_readme_formatter'
      require 'knife_cookbook_doc/formatter/template_readme_formatter'
      require 'knife_cookbook_doc/formatter/default_attributes_formatter'
      require 'knife_cookbook_doc/formatter/default_recipe_formatter'
      require 'knife_cookbook_doc/formatter/default_definition_formatter'
      require 'knife_cookbook_doc/formatter/default_resource_formatter'
      require 'knife_cookbook_doc/formatter/default_requirements_formatter'
      require 'knife_cookbook_doc/formatter/default_license_formatter'
    end

    banner 'knife cookbook doc DIR (options)'

    option :constraints,
           :short => '-c',
           :long => '--constraints',
           :boolean => true,
           :default => true,
           :description => 'Include version constraints for platforms and dependencies'

    option :output_file,
           :short => '-o',
           :long => '--output-file FILE',
           :default => 'README.md',
           :description => 'Set the output file to render to relative to cookbook dir. Defaults to README.md'

    option :template_file,
           :short => '-t',
           :long => '--template FILE',
           :default => Pathname.new("#{File.dirname(__FILE__)}/README.md.erb").realpath,
           :description => 'Set template file used to render README.md'

    def run
      unless (cookbook_dir = name_args.first)
        ui.fatal 'Please provide cookbook directory as an argument'
        exit(1)
      end

      cookbook_dir = File.realpath(cookbook_dir)

      config[:readme_formatter] = DefaultReadmeFormatter.new
      config[:attributes_formatter] = DefaultAttributesFormatter.new
      config[:recipe_formatter] = DefaultRecipeFormatter.new
      config[:definition_formatter] = DefaultDefinitionFormatter.new
      config[:resource_formatter] = DefaultResourceFormatter.new
      config[:requirements_formatter] = DefaultRequirementsFormatter.new
      config[:license_formatter] = DefaultLicenseFormatter.new

      model = ReadmeModel.new(cookbook_dir, config[:constraints])
      result = config[:readme_formatter].format(model, config)

      File.open("#{cookbook_dir}/#{config[:output_file]}", 'wb') do |f|
        result.each_line do |line|
          f.write line.gsub(/[ \t\r\n]*$/,'')
          f.write "\n"
        end
      end
    end
  end
end
