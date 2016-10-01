module MPM
  class NPM < Thor
    desc "uninstall...", "uninstall......"
    def uninstall(*packages)
      system "npm uninstall #{packages.join(" ")}"
    end

    desc "install...", "install......"
    def install(*packages)
      system "npm install #{packages.join(" ")}"
    end
    
    desc "list...", "list......"
    def list(*packages)
      system "npm list"
    end
  end

  class CLI < NPM
    desc "/npm COMMAND...ARGS", "Meta wrapper for 'npm'."
    subcommand "/npm", NPM
  end
end
