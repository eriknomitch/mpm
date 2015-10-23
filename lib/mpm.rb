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

    attr_accessor :executable, :os

    def initialize(executable, os)
      self.executable = executable
      self.os = os
    end

    def self.get
      pm_executable = ::MPM::Utility.get_pm_executable

      ::MPM.pm_provisioners.find do |pm_provisioner|
        pm_provisioner.executable == pm_executable
      end
    end

    def self.define(executable, os)
      ::MPM.pm_provisioners.add PMProvisioner.new(executable, os)
    end
  end

  # ----------------------------------------------
  # DEFINE->PMProvisioners -----------------------
  # ----------------------------------------------
  # FIX: Put these in ./pm_provisioners
  PMProvisioner.define "apt-get", :linux do
  end
  
  PMProvisioner.define "brew", :osx do
  end
  
end

puts ::MPM::PMProvisioner.get().executable
puts ::MPM::PMProvisioner.get().os

# ------------------------------------------------
# REQUIRE->POST ----------------------------------
# ------------------------------------------------
require "mpm/cli"

MPM::CLI.start(ARGV)
