module MPM
  class RubyGems < Thor
    desc "uninstall...", "uninstall......"
    def uninstall(*packages)
      system "gem uninstall #{packages.join(" ")}"
    end

    desc "install...", "install......"
    def install(*packages)
      system "gem install #{packages.join(" ")}"
    end

    desc "list...", "list......"
    def list(*packages)
      system "gem list"
    end
    
    desc "search...", "search......"
    def search(query)
      system "gem search #{query}"
    end
    
    desc "update...", "update......"
    def update(*packages)
      system "gem update #{packages.join(" ")}"
    end
  end

  class CLI < Thor
    desc "/gem COMMAND...ARGS", "Meta wrapper for 'gem'."
    subcommand "/gem", RubyGems
  end
end
