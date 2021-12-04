# frozen_string_literal: true

module Work
  module Md
    module Cli
      class CommandMissing < RuntimeError; end

      ALIAS_COMMANDS =
        {
          't' => 'today',
          'ty' => 'tyesterday',
          'y' => 'yesterday',
          'c' => 'config',
          'p' => 'parse',
          'pl' => 'plast',
          'a' => 'annotations',
          'l' => 'last',
          'o' => 'open',
          'tl' => 'tlast'
        }.freeze

      def self.execute(argv)
        first_argv_argument = argv.shift
        tag = fetch_argv_keys(argv)['tag']

        if tag
          ENV['WORK_MD_TAG'] = tag
          argv.reject! { |arg| arg.include?('-tag=') }
        end

        ::FileUtils.mkdir_p(Work::Md::Config.work_dir)

        raise CommandMissing if first_argv_argument.nil?

        command =
          (ALIAS_COMMANDS[first_argv_argument] ||
           first_argv_argument).capitalize

        Object
          .const_get("Work::Md::Commands::#{command}")
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
          '- work-md',
          '- work-md today',
          '- work-md yesterday',
          '- work-md tyesterday',
          '- work-md last',
          '- work-md tlast',
          '- work-md parse',
          '- work-md plast',
          '- work-md annotations',
          '- work-md open',
          '- work-md config',
          '',
          'for more information: github.com/work-md',
          **normal_frame_style
        )
        # rubocop:enable Layout/LineLength
      end

      def self.normal_frame_style
        {
          padding: 1,
          title: { top_left: '(work-md)', bottom_right: "(v#{Work::Md::VERSION})" }
        }
      end

      def self.error_frame_style
        {
          padding: 1,
          title: { top_left: '(error)' }
        }
      end

      def self.fetch_argv_keys(argv)
        Hash[argv.join(' ').scan(/-?([^=\s]+)(?:=(\S+))?/)]
      end
    end
  end
end
