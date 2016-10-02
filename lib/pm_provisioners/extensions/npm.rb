module MPM
  class NPM < Thor
    desc "uninstall...", "uninstall......"
    def uninstall(*packages)
      system "npm uninstall #{packages.join(" ")}"
    end

    # FIX: How to handle "npm install -g <package>"

    desc "install...", "install......"
    def install(*packages)
      system "npm install #{packages.join(" ")}"
    end
    
    desc "list...", "list......"
    def list(*packages)
      system "npm list"
    end
    
    desc "search...", "search......"
    def search(*packages)
      system "npm search"
    end
  end

  class CLI < Thor
    desc "/npm COMMAND...ARGS", "Meta wrapper for 'npm'."
    subcommand "/npm", NPM
  end
end
