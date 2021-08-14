# frozen_string_literal: true

module WorkMd
  module Cli
    class CommandMissing < RuntimeError; end

    ALIAS_COMMANDS =
      {
        't' => 'today',
        'ty' => 'tyesterday',
        'y' => 'yesterday',
        'c' => 'config',
        'p' => 'parse'
      }.freeze

    def self.execute(argv)
      first_argv_argument = argv.shift

      raise CommandMissing if first_argv_argument.nil?

      command =
        (ALIAS_COMMANDS[first_argv_argument] || first_argv_argument).capitalize

      Object
        .const_get("WorkMd::Commands::#{command}")
        .send(:execute, argv)
    rescue NameError
      puts help(
        ::TTY::Box.frame(
          "Command '#{first_argv_argument}' not found!",
          **error_frame_style
        )
      )
    rescue CommandMissing
      help('Welcome! =)')
    end

    def self.help(message = '')
      # rubocop:disable Layout/LineLength
      puts ::TTY::Box.frame(
        message,
        'Track your work activities, write annotations, recap what you did for a week, month or specific days... and much more!',
        '',
        'commands available:',
        '',
        '- work_md',
        '- work_md today',
        '- work_md yesterday',
        '- work_md tyesterday',
        '- work_md parse',
        '- work_md config',
        '',
        'more information in github.com/henriquefernandez/work_md',
        padding: 1,
        title: { top_left: '(work_md)', bottom_right: "(v#{WorkMd::VERSION})" }
      )
      # rubocop:enable Layout/LineLength
    end

    def self.error_frame_style
      {
        padding: 1,
        title: { top_left: '(error)' }
      }
    end
  end
end
