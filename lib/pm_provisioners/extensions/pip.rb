module MPM
  class Pip < Thor

    # FIX: IMPORTANT: Dependency on sudo -H is great.

    desc "uninstall...", "uninstall......"
    def uninstall(*packages)
      system "sudo -H pip uninstall #{packages.join(" ")}"
    end

    desc "install...", "install......"
    def install(*packages)
      system "sudo -H pip install #{packages.join(" ")}"
    end
    
    desc "list...", "list......"
    def list(*packages)
      system "sudo -H pip list"
    end
    
    desc "search...", "search......"
    def search(query)
      system "pip search #{query}"
    end
  end

  class CLI < Thor
    desc "/pip COMMAND...ARGS", "Meta wrapper for 'pip'."
    subcommand "/pip", Pip
  end
end
