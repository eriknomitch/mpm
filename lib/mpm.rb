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

  mattr_accessor :pm_provisioners

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
    [:install, :uninstall, :search].each do |name|
      define_method name do
        self.definitions_commands.add({
          method_name: name,
          definition:  definition
        })
      end
    end
    
    # --------------------------------------------
    # DEFINE/GET ---------------------------------
    # --------------------------------------------
    def self.define(executable, os, &definition)
      ::MPM.pm_provisioners.add PMProvisioner.new(executable, os, &definition)
    end
    
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
  PMProvisioner.define "apt-get", :linux do
    install do |package|
      ["install", package]
    end

    uninstall do |package|
      ["remove", package]
    end
    
    search do |package|
      executable "apt-cache"

      ["search", package]
    end
  end
  
  PMProvisioner.define "brew", :osx do
    install do |package|
      ["install", package]
    end
    
    uninstall do |package|
      ["uninstall", package]
    end

    search do |package|
      ["search", package]
    end
  end
  
end

#puts ::MPM::PMProvisioner.get().executable
#puts ::MPM::PMProvisioner.get().os

# ------------------------------------------------
# REQUIRE->POST ----------------------------------
# ------------------------------------------------
require "mpm/cli"

MPM::CLI.start(ARGV)
