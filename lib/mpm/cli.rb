# ------------------------------------------------
# MODULE->MPM ------------------------------------
# ------------------------------------------------
module MPM

  # ----------------------------------------------
  # CLASS->CLI (THOR) ----------------------------
  # ----------------------------------------------
  class CLI < Thor

    # --------------------------------------------
    # CONFIGURATION ------------------------------
    # --------------------------------------------
    package_name "mpm"
    
    # --------------------------------------------
    # COMMAND->SEARCH ----------------------------
    # --------------------------------------------
    # IDEA: Have a "chained grep" option for arguments after the package
    desc "search [--all|-a] PACKAGE", "Searches for a package in the list of available packages."
    def search(package)
      ::MPM.pm_provisioner.exec_command :search, package
    end

    map "--search" => "search"
    
    # FIX: Change this to an argument of "list"
    desc "search-installed PACKAGE", "Searches for a package in the list of installed packages."
    def search_installed(package)
      ::MPM.pm_provisioner.exec_command :search_installed, package
    end

    map "--search-installed" => "search-installed"
    
    # --------------------------------------------
    # COMMAND->INSTALL ---------------------------
    # --------------------------------------------
    # TODO: $ mpm install cask/hazel
    # TODO: $ mpm install gem/git-up
    desc "install PACKAGE", "Installs one or more packages."
    def install(*packages)
      ::MPM.pm_provisioner.exec_command :install, *packages
    end

    map "--install" => "install"
    
    # --------------------------------------------
    # COMMAND->UNINSTALL -------------------------
    # --------------------------------------------
    # TODO: Have 'remove' prompt "did you mean uninstall?" and run this
    desc "uninstall PACKAGE", "Uninstalls one or more packages."
    def uninstall(*packages)
      ::MPM.pm_provisioner.exec_command :uninstall, *packages
    end

    map "--uninstall" => "uninstall"
    
    # --------------------------------------------
    # COMMAND->LIST ------------------------------
    # --------------------------------------------
    desc "list", "Lists installed packages."
    def list()
      ::MPM.pm_provisioner.exec_command :list
    end

    map "--list" => "list"
    
    # --------------------------------------------
    # COMMAND->UPDATE ----------------------------
    # --------------------------------------------
    desc "update", "TODO"
    def update()
      ::MPM.pm_provisioner.exec_command :update
    end

    map "--update" => "update"
    
    # --------------------------------------------
    # COMMAND->UPGRADE ---------------------------
    # --------------------------------------------
    desc "update", "Upgrades a package."
    def upgrade()
      ::MPM.pm_provisioner.exec_command :upgrade
    end

    map "--upgrade" => "upgrade"
    
    # --------------------------------------------
    # COMMAND->INFO ------------------------------
    # --------------------------------------------
    desc "info PACKAGE", "Displays information about a package."
    def info(package)
      ::MPM.pm_provisioner.exec_command :info, package
    end

    map "--info" => "info"
   
    # TODO:
    # --------------------------------------------
    # * mpm installed details PACKAGE (Gets details on an installed package)
    # * mpm installed search PACKAGE
    #
    # * mpm upgrade cowsay # Ability to upgrade single packege.
    #
    # * How to handle 'apt-get autoremove'? mpm clean? mpm cleanup? mpm system-cleanup?
    #
    # * Have the ability to pass multiple extensions to search `mpm / /gem mruby` for 
    # the base package manager and /gem
    
    # --------------------------------------------
    # COMMAND->VERSION ---------------------------
    # --------------------------------------------
    desc "version", "Displays the current version of notify-push"
    def version()
      puts ::MPM::VERSION
    end

    map "--version" => "version"

  end

end

# ------------------------------------------------
# TRAP->SIGINT -----------------------------------
# ------------------------------------------------
trap "SIGINT" do
  exit 130
end

