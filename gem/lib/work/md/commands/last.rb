# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Last
        class << self
          def execute(argv = [])
            work_dir = Work::Md::Config.work_dir

            if argv == []
              current_day = Date.today.prev_day
              found_file = false

              (1..160).each do
                file_name = "#{current_day.strftime('%Y/%m/%d')}.md"

                if ::File.exist?("#{work_dir}/#{file_name}")
                  Work::Md::File.open_in_editor([file_name])
                  found_file = true
                  break
                end

                current_day = current_day.prev_day
              end

              unless found_file
                Work::Md::Cli.help(
                  ::TTY::Box.frame(
                    "message: No file found in last 5 months",
                    **Work::Md::Cli.error_frame_style
                  )
                )
              end

              return
            end

            to_open = []
            is_numeric = ->(str) {
              str == "#{str.to_f}" || str == "#{str.to_i}"
            }

            if is_numeric.(argv.first)
              last_n = argv.first.to_i
            else
              Work::Md::Cli.help(
                ::TTY::Box.frame(
                  "message: 'last' command accept only numeric arguments, you give: #{argv.inspect}",
                  '',
                  'Usage example:',
                  '',
                  'work-md l 7     # open the last 7 days',
                  'work-md l       # open the last day',
                  **Work::Md::Cli.error_frame_style
                )
              )
              return
            end

            last_date = Date.today.prev_day

            (1..last_n).map do
              last_file_name = "#{last_date.strftime('%Y/%m/%d')}.md"

              if ::File.exist?("#{work_dir}/#{last_file_name}")
                to_open.push("#{work_dir}/#{last_file_name}")
              else
                nil
              end

              last_date = last_date.prev_day
            end

            Work::Md::File.open_in_editor(to_open)
          end
        end
      end
    end
  end
end
