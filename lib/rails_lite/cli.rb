require 'thor'
require 'fileutils'

module RailsLite

  class CLI < Thor

    desc "new", "Creates a new rails lite project"
    method_option aliases: "n"
    def new(*words)
      words = ['new', 'app'] if words.empty?
      name = words.join('_')
      directory = File.dirname(__FILE__)
      source = File.join(directory, "..", "scaffold")
      FileUtils.cp_r source, FileUtils.pwd
      FileUtils.mv(File.join(FileUtils.pwd, "scaffold"), File.join(FileUtils.pwd, name))
    end

    desc "server", "Starts the rails lite server"
    method_option aliases: "s"
    def server
      root = FileUtils.pwd
      file_name = File.join(root, 'bin', 'server')
      if File.exist?(file_name)
        system('bin/server')
      else
        puts "Not a rails lite directory"
      end
    end

    desc "console", "Starts the rails lite console"
    method_option aliases: "c"
    def console
      root = FileUtils.pwd
      file_name = File.join(root, 'bin', 'pry')
      if File.exist?(file_name)
        system('bin/pry')
      else
        puts "Not a rails lite directory"
      end
    end

    desc "routes", "Displays the current routes"
    def routes
      root = FileUtils.pwd
      file_name = File.join(root, 'bin', 'routes')
      if File.exist?(file_name)
        system('bin/routes')
      else
        puts "Not a rails lite directory"
      end
    end
  end
end
