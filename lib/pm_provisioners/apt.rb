# ==============================================
# DEFINE->PM-PROVISIONER->APT ==================
# ==============================================
# FIX: It's not really apt-get since search is apt-cache... It's just "apt".
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

