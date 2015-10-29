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
    desc "search|--search PACKAGE", "Searches for a package in the list of available packages."
    def search(package)
      ::MPM.pm_provisioner.exec_command :search, package
    end

    map "--search" => "search"
    
    # --------------------------------------------
    # COMMAND->INSTALL ---------------------------
    # --------------------------------------------
    desc "install|--install PACKAGE", "Installs one or more packages."
    def install(*packages)
      ::MPM.pm_provisioner.exec_command :install, *packages
    end

    map "--install" => "install"
    
    # --------------------------------------------
    # COMMAND->UNINSTALL -------------------------
    # --------------------------------------------
    desc "uninstall|--uninstall PACKAGE", "Uninstalls one or more packages."
    def uninstall(*packages)
      ::MPM.pm_provisioner.exec_command :uninstall, *packages
    end

    map "--uninstall" => "uninstall"
    
    # --------------------------------------------
    # COMMAND->LIST ------------------------------
    # --------------------------------------------
    desc "list|--list", "Lists installed packages."
    def list()
      ::MPM.pm_provisioner.exec_command :list
    end

    map "--list" => "list"
    
    # --------------------------------------------
    # COMMAND->UPDATE ----------------------------
    # --------------------------------------------
    desc "update|--update", "Updates the local package index from remote."
    def update()
      ::MPM.pm_provisioner.exec_command :update
    end

    map "--update" => "update"
    
    # --------------------------------------------
    # COMMAND->INFO ------------------------------
    # --------------------------------------------
    desc "info|--info PACKAGE", "Displays information about a package."
    def info(package)
      ::MPM.pm_provisioner.exec_command :info, package
    end

    map "--info" => "info"
    
    # --------------------------------------------
    # COMMAND->VERSION ---------------------------
    # --------------------------------------------
    desc "version|--version", "Displays the current version of notify-push"
    def version()
      puts "FIX"
      #puts ::MPM::VERSION
    end

    map "--version" => "version"

  end

end
