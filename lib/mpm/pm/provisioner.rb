module MPM
  module PM

    # --------------------------------------------
    # CLASS->PROVISIONER -------------------------
    # --------------------------------------------
    class Provisioner

      # ------------------------------------------
      # CONSTANTS --------------------------------
      # ------------------------------------------
      DEFINITION_DSL_METHODS = %i(
        install
        uninstall
        search
        search_installed
        list
        update
        info
      )

      # ------------------------------------------
      # ATTRIBUTES -------------------------------
      # ------------------------------------------
      attr_accessor *%i(
        executable
        os
        definition
        definitions_commands
        extensions
      )

      # ------------------------------------------
      # INITIALIZE -------------------------------
      # ------------------------------------------
      def initialize(executable, os, &definition)
        self.executable = executable
        self.os         = os
        self.definition = definition
        
        self.definitions_commands = Set.new
        self.extensions = Set.new

        # Evaluate the block/DSL
        self.instance_eval &self.definition
      end

      # ------------------------------------------
      # DSL --------------------------------------
      # ------------------------------------------
      DEFINITION_DSL_METHODS.each do |name|
        define_method name do |&definition|
          self.definitions_commands.add({
            method_name: name,
            definition:  definition
          })
        end
      end

      def extension(name, &definition)
        new_extension = ::MPM::PM::Extension.new name, &definition
        self.extensions.add new_extension
      end
      
      # ------------------------------------------
      # COMMAND->RETREIVAL -----------------------
      # ------------------------------------------
      def find_command(command_name)
        self.definitions_commands.find do |definition_command|
          definition_command[:method_name] == command_name.to_sym
        end
      end
      
      # ------------------------------------------
      # COMMAND->EXECUTION -----------------------
      # ------------------------------------------
      def exec_command(command_name, *arguments)
        command = find_command command_name

        executable = ::MPM.pm_provisioner.executable

        # TEMPORARY: FIX:
        if executable == "apt-get"
          executable = "apt-cache" if [:search, :info].member? command_name.to_sym
          executable = "dpkg" if command_name.to_sym == :list
          executable = "dpkg-query" if command_name.to_sym == :search_installed
        end

        # Execute the command from the executable and the definition.
        command = [executable].concat(command[:definition].call(*arguments))

        # TEMPORARY: FIX:
        command.unshift("sudo") if executable == "apt-get"

        final_command = command.join(" ")

        puts "executing: #{final_command}"
        
        system final_command
      end
      
      # ------------------------------------------
      # PM-PROVISIONERS->DEFINITION --------------
      # ------------------------------------------
      def self.define(executable, os, &definition)
        ::MPM.pm_provisioners.add Provisioner.new(executable, os, &definition)
      end
      
      # ------------------------------------------
      # PM-PROVISIONERS->RETRIEVAL ---------------
      # ------------------------------------------
      def self.get
        pm_executable = ::MPM::Utility.get_pm_executable

        ::MPM.pm_provisioners.find do |pm_provisioner|
          pm_provisioner.executable == pm_executable
        end
      end
    
    end
  end
end

