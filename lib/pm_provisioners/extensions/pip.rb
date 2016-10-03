module MPM
  class Pip < Thor

    # FIX: IMPORTANT: Dependency on sudo is very bad and it's not supposed to be the case.

    desc "uninstall...", "uninstall......"
    def uninstall(*packages)
      system "sudo pip uninstall #{packages.join(" ")}"
    end

    desc "install...", "install......"
    def install(*packages)
      system "sudo pip install #{packages.join(" ")}"
    end
    
    desc "list...", "list......"
    def list(*packages)
      system "sudo pip list"
    end
    
    desc "search...", "search......"
    def search(*packages)
      system "sudo pip search"
    end
  end

  class CLI < Thor
    desc "/pip COMMAND...ARGS", "Meta wrapper for 'pip'."
    subcommand "/pip", Pip
  end
end
