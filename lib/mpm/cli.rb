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
    desc "search PACKAGE", "Searches for a package in the list of available packages."
    def search(package)
      ::MPM.pm_provisioner.exec_command :search, package
    end

    map "--search" => "search"
    
    # --------------------------------------------
    # COMMAND->INSTALL ---------------------------
    # --------------------------------------------
    # TODO: $ mpm install cask/hazel
    desc "install PACKAGE", "Installs one or more packages."
    def install(*packages)
      ::MPM.pm_provisioner.exec_command :install, *packages
    end

    map "--install" => "install"
    
    # --------------------------------------------
    # COMMAND->UNINSTALL -------------------------
    # --------------------------------------------
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
    # COMMAND->INSTALLED -------------------------
    # --------------------------------------------
    desc "installed", "Searches installed packages."
    def installed(subcommand=nil)

      # Use this:
      # http://www.cyberciti.biz/faq/find-out-if-package-is-installed-in-linux/
      #
      # dpkg-query --list cowsay
      # dpkg-query --list cow*
      #
      #::MPM.pm_provisioner.exec_command :installed
      
      puts subcommand
    
    end

    map "--installed" => "installed"
    
    # --------------------------------------------
    # COMMAND->UPDATE ----------------------------
    # --------------------------------------------
    desc "update", "Updates the local package index from remote."
    def update()
      ::MPM.pm_provisioner.exec_command :update
    end

    map "--update" => "update"
    
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
    
    # --------------------------------------------
    # COMMAND->VERSION ---------------------------
    # --------------------------------------------
    desc "version", "Displays the current version of notify-push"
    def version()
      puts "FIX"
      #puts ::MPM::VERSION
    end

    map "--version" => "version"

  end

end
