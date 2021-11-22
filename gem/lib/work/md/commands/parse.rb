# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Parse
        class << self
          def execute(argv = [])
            parser = Work::Md::Parser::Engine.new
            argv_keys_to_parser = -> (argv_keys, received_parser) {
              year = argv_keys['y'] || Time.new.year
              month = argv_keys['m'] || Time.new.month

              month = "0#{month.to_i}" if month.to_i < 10

              add_file_to_parser = lambda do |day|
                day = "0#{day.to_i}" if day.to_i < 10

                file_name = Work::Md::Config.work_dir + "/#{year}/#{month}/#{day}.md"

                received_parser.add_file(file_name)
              end

              if argv_keys['d'].include?('..')
                range = argv_keys['d'].split('..')

                (range[0].to_i..range[1].to_i).each { |day| add_file_to_parser.call(day) }
              else
                argv_keys['d'].split(',').each { |day| add_file_to_parser.call(day) }
              end

              received_parser
            }

            argv.join('#').split('#and#').map { |v| v.split("#") }.each do |args|
              argv_keys_to_parser.(Work::Md::Cli.fetch_argv_keys(args), parser)
            end

            Work::Md::File.create_and_open_parsed(parser)
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
