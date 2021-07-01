# frozen_string_literal: true

module WorkMd
  module Cli
    class CommandMissing < RuntimeError; end

    def self.execute(argv)
      first_argv_argument = argv.shift

      raise CommandMissing if first_argv_argument.nil?

      Object
        .const_get("WorkMd::Commands::#{first_argv_argument.capitalize}")
        .send(:execute, argv)
    rescue NameError
      error("Command #{first_argv_argument} not found!")
    rescue CommandMissing
      error('Command missing!')
    end

    def self.error(message)
      puts 'x - Error ------ x'
      puts ''
      puts message
      puts ''
      puts 'x -------------- x'
    end
  end
end
