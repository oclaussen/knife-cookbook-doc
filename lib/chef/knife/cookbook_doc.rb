require 'chef/knife'
require 'pathname'

module KnifeCookbookDoc
  class CookbookDoc < Chef::Knife
    deps do
      require 'knife_cookbook_doc'
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

      KnifeCookbookDoc.create_doc(File.realpath(cookbook_dir), config)
    end
  end
end
