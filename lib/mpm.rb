# ================================================
# MPM ============================================
# ================================================
require "json"
require "shellwords"
require "yaml"
require "recursive-open-struct"
require "thor"
require "thor/group"
require "awesome_print"
require "active_support/core_ext/hash/reverse_merge"
require "active_support/core_ext/module"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/try"
require "active_support/inflector/inflections"
#require "os"
require "os-name"

# FIX: Development only
require "pry" if Gem::Specification::find_all_by_name("pry").any?

# http://headynation.com/opposite-of-chomp-in-ruby/
class String
  def remove_from_beginning(string_to_remove)
    len = string_to_remove.size
    if self[0..(len-1)] == string_to_remove
      return self[len..-1]
    end
    self
  end
end

# ------------------------------------------------
# MODULE->MPM ------------------------------------
# ------------------------------------------------
module MPM
  
  # ----------------------------------------------
  # CONSTANTS ------------------------------------
  # ----------------------------------------------
  VERSION = Gem.loaded_specs["mpm"].version

  # ----------------------------------------------
  # ATTRIBUTES -----------------------------------
  # ----------------------------------------------
  # pm_provisioners: The Set of all the defined PackageManagerProvisioners
  # pm_provisioner:  The currently selected PackageManagerProvisioner for this OS/platform.
  mattr_accessor *%i(
    pm_provisioners
    pm_provisioner
  )

  self.pm_provisioners = Set.new

  # ----------------------------------------------
  # MODULE->UTILITY ------------------------------
  # ----------------------------------------------
  module Utility
    def self.get_os()
      OS.to_sym
    end

    def self.get_pm_executable()
      case get_os
      when :linux
        # FIX: Detect distro...
        "apt-get"
      when :osx
        # FIX: Ensure brew, etc.
        "brew"
      end
    end
  end
  
  # ----------------------------------------------
  # MAIN -----------------------------------------
  # ----------------------------------------------
 
  Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), "mpm/pm/*.rb"))).each do |file|
    load file
  end

  # Load the PM::Provisioner definitions from their own files.
  Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), "pm_provisioners", "*.rb"))).each do |file|
    instance_eval File.read(file)
  end

  # Find and set the main PM::Provisioner that this machine will use.
  self.pm_provisioner = ::MPM::PM::Provisioner.get()
  
end

# ------------------------------------------------
# REQUIRE->POST ----------------------------------
# ------------------------------------------------
require "mpm/cli"

MPM::CLI.start ARGV
