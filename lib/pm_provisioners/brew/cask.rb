module MPM
  if Utility.get_os == :osx
    class BrewCask < Thor
      desc "uninstall...", "uninstall......"
      def uninstall(*packages)
        system "brew cask uninstall #{packages.join(" ")}"
      end

      desc "install...", "install......"
      def install(*packages)
        system "brew cask install #{packages.join(" ")}"
      end
      
      desc "list...", "list......"
      def list(*packages)
        system "brew cask list"
      end
    end

    class CLI < Thor
      desc "/cask COMMAND...ARGS", "Meta wrapper for 'brew cask'."
      subcommand "/cask", BrewCask
    end
  end
end
