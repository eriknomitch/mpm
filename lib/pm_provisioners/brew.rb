# ----------------------------------------------
# DEFINE->PM-PROVISIONER->BREW -----------------
# ----------------------------------------------
PM::Provisioner.define "brew", :osx do
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

Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), "lib/pm_provisioners/brew", "*.rb"))).each do |file|
  #load file
end


