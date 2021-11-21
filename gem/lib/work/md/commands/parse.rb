# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Parse
        class << self
          def execute(argv = [])
            parser = Work::Md::Parser::Engine.new
            args_hash_to_parser = -> (args, received_parser) {
              year = args['y'] || Time.new.year
              month = args['m'] || Time.new.month

              month = "0#{month.to_i}" if month.to_i < 10

              add_file_to_parser = lambda do |day|
                day = "0#{day.to_i}" if day.to_i < 10

                file_name = Work::Md::Config.work_dir + "/#{year}/#{month}/#{day}.md"

                received_parser.add_file(file_name)
              end

              if args['d'].include?('..')
                range = args['d'].split('..')

                (range[0].to_i..range[1].to_i).each { |day| add_file_to_parser.call(day) }
              else
                args['d'].split(',').each { |day| add_file_to_parser.call(day) }
              end

              received_parser
            }

            argv.join('#').split('#and#').map { |v| v.split("#") }.each do |args|
              args_hash = Hash[args.join(' ').scan(/-?([^=\s]+)(?:=(\S+))?/)]
              args_hash_to_parser.(args_hash, parser)
            end

            Work::Md::File.create_and_open_parsed(parser)
          rescue StandardError => e
            Work::Md::Cli.help(
              ::TTY::Box.frame(
                "message: #{e.message}",
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
