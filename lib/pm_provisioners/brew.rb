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

  # ----------------------------------------------
  # ->EXTENSION->CASK ----------------------------
  # ----------------------------------------------
  extension "cask" do
    install do |*packages|
      ["cask", "install", *packages]
    end
  end

end

class CLI < Thor
  desc "foo", "Foo"
  def foo()
    puts "ok"
  end
end
