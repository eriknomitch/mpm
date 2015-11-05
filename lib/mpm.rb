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
  # CLASS->PMProvisioner -------------------------
  # ----------------------------------------------
  class PMProvisioner

    # --------------------------------------------
    # ATTRIBUTES ---------------------------------
    # --------------------------------------------
    attr_accessor *%i(
      executable
      os
      definition
      definitions_commands
    )

    # --------------------------------------------
    # INITIALIZE ---------------------------------
    # --------------------------------------------
    def initialize(executable, os, &definition)
      self.executable = executable
      self.os         = os
      self.definition = definition
      
      self.definitions_commands = Set.new

      # Evaluate the block/DSL
      self.instance_eval &self.definition
    end

    # --------------------------------------------
    # DSL ----------------------------------------
    # --------------------------------------------
    [:install, :uninstall, :search, :search_installed, :list, :update, :info].each do |name|
      define_method name do |&definition|
        self.definitions_commands.add({
          method_name: name,
          definition:  definition
        })
      end
    end
    
    # --------------------------------------------
    # COMMAND->RETREIVAL -------------------------
    # --------------------------------------------
    def find_command(command_name)
      self.definitions_commands.find do |definition_command|
        definition_command[:method_name] == command_name.to_sym
      end
    end
    
    # --------------------------------------------
    # COMMAND->EXECUTION -------------------------
    # --------------------------------------------
    def exec_command(command_name, *arguments)
      command = find_command command_name

      executable = ::MPM.pm_provisioner.executable
      
      # TEMPORARY: FIX:
      if executable == "apt-get"
        executable = "apt-cache" if [:search, :info].member? command_name.to_sym
        executable = "dpkg" if command_name.to_sym == :list
        executable = "dpkg-query" if command_name.to_sym == :search_installed
      end

      # Execute the command from the executable and the definition.
      command = [executable].concat(command[:definition].call(*arguments))

      # TEMPORARY: FIX:
      command.unshift("sudo") if executable == "apt-get"
      
      system command.join(" ")
    end
    
    # --------------------------------------------
    # PM-PROVISIONERS->DEFINITION ----------------
    # --------------------------------------------
    def self.define(executable, os, &definition)
      ::MPM.pm_provisioners.add PMProvisioner.new(executable, os, &definition)
    end
    
    # --------------------------------------------
    # PM-PROVISIONERS->RETRIEVAL -----------------
    # --------------------------------------------
    def self.get
      pm_executable = ::MPM::Utility.get_pm_executable

      ::MPM.pm_provisioners.find do |pm_provisioner|
        pm_provisioner.executable == pm_executable
      end
    end
    
  end

  # ----------------------------------------------
  # DEFINE->PMProvisioners -----------------------
  # ----------------------------------------------
  # FIX: Put these in ./pm_provisioners
  
  # ----------------------------------------------
  # DEFINE->PM-PROVISIONER->APT ------------------
  # ----------------------------------------------
  # FIX: It's not really apt-get since search is apt-cache
  PMProvisioner.define "apt-get", :linux do
    install do |*packages|
      #sudo true
      ["install", *packages]
    end

    uninstall do |*packages|
      #sudo true
      # FIX: What about --purge?
      ["remove", *packages]
    end
    
    search do |package|
      #executable "apt-cache" 
      ["search", package]
    end
    
    search_installed do |package|

      #executable "dpkg-query"

      # http://www.cyberciti.biz/faq/find-out-if-package-is-installed-in-linux/
      #
      # dpkg-query --list cowsay
      # dpkg-query --list cow*
      #
      #::MPM.pm_provisioner.exec_command :installed
      ["--list", package]
    end


    list do 
      #executable "dpkg"
      ["-l"]
    end
    
    update do
      ["update"]
    end
    
    info do |package|
      #executable cpt-cache
      ["show", package]
    end
  end

  # ----------------------------------------------
  # DEFINE->PM-PROVISIONER->BREW -----------------
  # ----------------------------------------------
  PMProvisioner.define "brew", :osx do
    install do |*packages|
      ["install", *packages]
    end
    
    uninstall do |*packages|
      ["uninstall", *packages]
    end

    search do |package|
      ["search", package]
    end

    search_installed do |package|
      #executable "apt-cache" 
      ["search", package, "|", "grep", "-i", package]
    end

    list do
      ["list"]
    end

    update do
      ["update"]
    end
    
    info do |package|
      ["info", package]
    end
  end

  # ----------------------------------------------
  # MAIN -----------------------------------------
  # ----------------------------------------------

  # Find and set the main PMProvisioner that this machine will use.
  self.pm_provisioner = ::MPM::PMProvisioner.get()

end

# ------------------------------------------------
# REQUIRE->POST ----------------------------------
# ------------------------------------------------
require "mpm/cli"

MPM::CLI.start(ARGV)
