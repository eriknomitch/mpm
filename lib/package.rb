# ================================================
# PACKAGE ========================================
# ================================================
require "json"
require "shellwords"
require "yaml"
require "recursive-open-struct"
require "thor"
require "thor/group"
require "awesome_print"

# FIX: Development only
require "pry" if Gem::Specification::find_all_by_name("pry").any?

# ------------------------------------------------
# MODULE->PACKAGE --------------------------------
# ------------------------------------------------
module Package
  def self.main
    puts "ok test"
  end

  class PMProvisioner
  end
end
