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

# FIX: Development only
require "pry" if Gem::Specification::find_all_by_name("pry").any?

# ------------------------------------------------
# MODULE->MPM ------------------------------------
# ------------------------------------------------
module MPM

  mattr_accessor :pm_provisioners

  self.pm_provisioners = Set.new

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
    end

    def self.define(executable, os)
      ::MPM.pm_provisioners.add PMProvisioner.new(executable, os)
    end
  end

  # ----------------------------------------------
  # DEFINE->PMProvisioners -----------------------
  # ----------------------------------------------
  PMProvisioner.define "apt-get", "Linux" do
  end
  
end

binding.pry

# ------------------------------------------------
# REQUIRE->POST ----------------------------------
# ------------------------------------------------
require "mpm/cli"

MPM::CLI.start(ARGV)
