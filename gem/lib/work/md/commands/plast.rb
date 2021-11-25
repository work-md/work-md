# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Plast
        class << self
          def execute(argv = [])
            is_numeric = ->(str) {
              str == "#{str.to_f}" || str == "#{str.to_i}"
            }

            if is_numeric.(argv.first)
              last_n = argv.first.to_i
            else
              Work::Md::Cli.help(
                ::TTY::Box.frame(
                  "message: 'plast' command accept only numeric arguments, you give: #{argv.inspect}",
                  '',
                  'Usage example:',
                  '',
                  'work-md pl 7       # parse the last 7 days',
                  **Work::Md::Cli.error_frame_style
                )
              )
              return
            end

            last_date = Date.today.prev_day
            work_dir = Work::Md::Config.work_dir
            parser = Work::Md::Parser::Engine.new

            (1..last_n).map do
              last_file_name = "#{last_date.strftime('%Y/%m/%d')}.md"
              if ::File.exist?("#{work_dir}/#{last_file_name}")
                parser.add_file("#{work_dir}/#{last_file_name}")
              else
                nil
              end

              last_date = last_date.prev_day
            end

            Work::Md::File.create_and_open_parsed(parser)
          rescue StandardError
            Work::Md::Cli.help(
              ::TTY::Box.frame(
                "message: Some of verified markdown files may be with an incorrect format",
                '',
                'Usage example:',
                '',
                'work-md pl 7       # parse the last 7 days',
                **Work::Md::Cli.error_frame_style
              )
            )
          end
        end
      end
    end
  end
end
