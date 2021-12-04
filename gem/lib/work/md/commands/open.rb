# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Open
        class << self
          def execute(argv = [])
            to_open = []

            argv_keys_to_parser = -> (argv_keys, received_to_open) {
              year = argv_keys['y'] || Time.new.year
              month = argv_keys['m'] || Time.new.month

              month = "0#{month.to_i}" if month.to_i < 10

              add_file_to_parser = lambda do |day|
                day = "0#{day.to_i}" if day.to_i < 10

                file_name = Work::Md::Config.work_dir + "/#{year}/#{month}/#{day}.md"

                if ::File.exist? file_name
                  received_to_open.push(file_name)
                end
              end

              if argv_keys['d'].include?('..')
                range = argv_keys['d'].split('..')

                (range[0].to_i..range[1].to_i).each { |day| add_file_to_parser.call(day) }
              else
                argv_keys['d'].split(',').each { |day| add_file_to_parser.call(day) }
              end

              received_to_open
            }

            argv.join('#').split('#and#').map { |v| v.split("#") }.each do |args|
              argv_keys_to_parser.(Work::Md::Cli.fetch_argv_keys(args), to_open)
            end

            if to_open == []
              puts ::TTY::Box.frame(
                  "message: File(s) not found!",
                  **Work::Md::Cli.error_frame_style
                )

              return
            end

            Work::Md::File.open_in_editor(to_open)
          rescue StandardError
            Work::Md::Cli.help(
              ::TTY::Box.frame(
                "message: Some error occurred interpreting your command!",
                '',
                'Usage examples:',
                '',
                'work-md o -d=1 -m=5 -y=2000 # open day 1 from month 5 and year 2000',
                'work-md o -d=1,2,3          # open day 1, 2 and 3 from the current month and year',
                'work-md o -d=1,2 -m=4       # open day 1 and 2 from month 4 and current year',
                'work-md o -d=1..10 -m=4     # open day 1 to 10 from month 4 and current year',
                'work-md o -d=1..25 -m=2 and -d=1..25 -m=2 -y=1999     # open day 1 to 25 from month 2 and current year and 1 to 25 from month 2 in 1999',
                **Work::Md::Cli.error_frame_style
              )
            )
          end
        end
      end
    end
  end
end
