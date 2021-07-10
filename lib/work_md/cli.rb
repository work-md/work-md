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
      puts info(
        ::TTY::Box.frame(
          "Command '#{first_argv_argument}' not found!",
          error_frame_style
        )
      )
    rescue CommandMissing
      DEFAULT_COMMAND.execute(argv)
    end

    def self.info(message = '')
      # rubocop:disable Layout/LineLength
      puts ::TTY::Box.frame(
        message,
        'Track your work activities, write annotations, recap what you did for a week, month or specific days... and much more!',
        '',
        'commands available:',
        '',
        '- work_md',
        '- work_md today',
        '- work_md parse',
        '',
        'read more in github.com/henriquefernandez/work_md',
        padding: 1,
        title: { top_left: '(WorkMd)', bottom_right: "(v#{WorkMd::VERSION})" }
      )
      # rubocop:enable Layout/LineLength
    end

    def self.error_frame_style
      {
        padding: 1,
        title: { top_left: '(Error)' }
      }
    end
  end
end
