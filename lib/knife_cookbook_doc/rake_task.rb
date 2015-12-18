require 'rake'
require 'rake/tasklib'
require 'knife_cookbook_doc'

module KnifeCookbookDoc
  class RakeTask < ::Rake::TaskLib
    attr_accessor :name, :options

    def initialize(name = :knife_cookbook_doc)
      @name = name
      @options = {}
      yield self if block_given?

      desc 'Generate cookbook documentation' unless ::Rake.application.last_comment
      task(name) do
        ::KnifeCookbookDoc.create_doc(merged_options[:cookbook_dir], options)
      end
    end
  end
end
