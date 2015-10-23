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
    desc "install|--install PACKAGE", "Installs a package."
    def install(package)
      ::MPM.pm_provisioner.exec_command :install, package
    end

    map "--install" => "install"
    
    # --------------------------------------------
    # COMMAND->UNINSTALL -------------------------
    # --------------------------------------------
    desc "uninstall|--uninstall PACKAGE", "Uninstalls a package."
    def uninstall(package)
      ::MPM.pm_provisioner.exec_command :uninstall, package
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
