require 'thor'
require 'fileutils'

module RailsLite

  class CLI < Thor
    desc "new", "Creates a new rails lite project"
    method_options :string
    def new(name = "new_app")
      directory = File.dirname(__FILE__)
      source = File.join(directory, "..", "scaffold")
      FileUtils.cp_r source, FileUtils.pwd
      FileUtils.mv(File.join(FileUtils.pwd, "scaffold"), File.join(FileUtils.pwd, name))
    end
  end
end
