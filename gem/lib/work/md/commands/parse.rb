# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Parse
        class << self
          def execute(argv = [])
            parser = Work::Md::Parser::Engine.new

            Work::Md::DateFile
              .list_file_paths_by_argv_query(argv)
              .each { |file_path| parser.add_file(file_path) }

            Work::Md::File.create_and_open_parsed(parser)
          rescue Work::Md::Parser::Error => e
            Work::Md::Cli.help(e.message)
          rescue StandardError
            Work::Md::Cli.help(
              ::TTY::Box.frame(
                "message: Some of verified markdown files may be with an incorrect format",
                '',
                'Usage examples:',
                '',
                'work-md p -d=1 -m=5 -y=2000 # get day 1 from month 5 and year 2000',
                'work-md p -d=1,2,3          # get day 1, 2 and 3 from the current month and year',
                'work-md p -d=1,2 -m=4       # get day 1 and 2 from month 4 and current year',
                'work-md p -d=1..10 -m=4     # get day 1 to 10 from month 4 and current year',
                'work-md p -d=1..25 -m=2 and -d=1..25 -m=2 -y=1999     # get day 1 to 25 from month 2 and current year and 1 to 25 from month 2 in 1999',
                **Work::Md::Cli.error_frame_style
              )
            )
          end
        end
      end
    end
  end
end
