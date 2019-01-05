require 'thor'
require 'fileutils'

module RailsLite

  class CLI < Thor
    desc "new", "Creates a new rails lite project"
    # method_option :value, :lazy_default => "new_app"
    def new(name = "new_app")
      directory = File.dirname(__FILE__)
      source = File.join(directory, "..", "to_copy")
      FileUtils.cp_r source, FileUtils.pwd

      FileUtils.mv(File.join(FileUtils.pwd, "to_copy"), File.join(FileUtils.pwd, name))
    end
  end
end
