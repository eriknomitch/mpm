# ================================================
# MPM ============================================
# ================================================

# ------------------------------------------------
# REQUIRE->PRE -----------------------------------
# ------------------------------------------------
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
require "os-name"
require "colorize"

# FIX: Development only
require "pry" if Gem::Specification::find_all_by_name("pry").any?

# ------------------------------------------------
# ->CLASS->STRING --------------------------------
# ------------------------------------------------
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
  VERSION = Gem.loaded_specs["meta-package-manager"].version

  # ----------------------------------------------
  # ATTRIBUTES -----------------------------------
  # ----------------------------------------------
  # pm_provisioners: The Set of all the defined PackageManagerProvisioners
  # pm_provisioner:  The currently selected PackageManagerProvisioner for this OS/platform.
  mattr_accessor *%i(
    pm_provisioners
    pm_provisioner
    config
  )

  self.pm_provisioners = Set.new

  self.config = {
    output_translation: true
  }

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
      when :osx, :macos
        # FIX: Ensure brew, etc.
        "brew"
      end
    end

    # --------------------------------------------
    # FILE-LOADING -------------------------------
    # --------------------------------------------
    def self.glob_in_pwd(*path_suffixes)
      Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), *path_suffixes)))
    end

    def self.load_from_glob_in_pwd(*path_suffixes)
      glob_in_pwd(*path_suffixes).each do |file|
        load file
      end
    end

    def self.instance_eval_from_glob_in_pwd(instance, *path_suffixes)
      glob_in_pwd(*path_suffixes).each do |file|
        instance.instance_eval File.read(file)
      end
    end

  end
  
  # ----------------------------------------------
  # MAIN -----------------------------------------
  # ----------------------------------------------

  # Load additional files
  # ----------------------------------------------
  # Load the base modules/classes for Provisioner and Extension
  Utility.load_from_glob_in_pwd "mpm/pm/*.rb"

  # Load the Provisioners definitions from their own files.
  Utility.instance_eval_from_glob_in_pwd self, "pm_provisioners/*.rb"
 
  # Load the Provisioners extensions (after their base Provisioners
  # have been loaded)
  Utility.load_from_glob_in_pwd "pm_provisioners/*/**.rb"

  # Set main Provisioner
  # ----------------------------------------------
  # Find and set the main Provisioners that this machine will use.
  self.pm_provisioner = ::MPM::PM::Provisioner.get()
  
end

# ------------------------------------------------
# REQUIRE->POST ----------------------------------
# ------------------------------------------------
require "mpm/cli"

# ================================================
# MAIN ===========================================
# ================================================
MPM::CLI.start ARGV
