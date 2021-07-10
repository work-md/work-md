# frozen_string_literal: true

module WorkMd
  module Cli
    class CommandMissing < RuntimeError; end

    ALIAS_COMMANDS =
      {
        't' => 'today',
        'p' => 'parse'
      }.freeze

    DEFAULT_COMMAND = WorkMd::Commands::Today

    def self.execute(argv)
      first_argv_argument = argv.shift

      raise CommandMissing if first_argv_argument.nil?

      command =
        (ALIAS_COMMANDS[first_argv_argument] || first_argv_argument).capitalize

      Object
        .const_get("WorkMd::Commands::#{command}")
        .send(:execute, argv)
    rescue NameError
      error("Command '#{first_argv_argument}' not found!")
    rescue CommandMissing
      DEFAULT_COMMAND.execute(argv)
    end

    # TODO: Create messages specific class
    def self.error(message)
      puts 'x - work_md error ------ x'
      puts ''
      puts message
      puts ''
      puts 'x ---------------------- x'
    end
  end
end
