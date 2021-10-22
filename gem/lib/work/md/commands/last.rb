# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Last
        class << self
          def execute(_argv = [])
            found_file = false
            current_day = Date.today.prev_day
            work_dir = Work::Md::Config.work_dir

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
          end
        end
      end
    end
  end
end
