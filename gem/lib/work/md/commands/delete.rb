# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Delete
        class << self
          def execute(argv = [])
            prompt = TTY::Prompt.new

            file_paths = Work::Md::DateFile.list_file_paths_by_argv_query(argv)

            if file_paths == []
              puts ::TTY::Box.frame(
                "message: File(s) not found!",
                **Work::Md::Cli.error_frame_style
              )

              return
            end

            file_paths.each do |file_name|
              if prompt.yes?("Do you really want to delete \"#{file_name}\"!?")
                ::File.delete(file_name)
              end
            end
          rescue StandardError
            Work::Md::Cli.help(
              ::TTY::Box.frame(
                "message: Some error occurred interpreting your command!",
                '',
                'Usage examples:',
                '',
                'work-md d -d=1 -m=5 -y=2000 # delete day 1 from month 5 and year 2000',
                'work-md d -d=1,2,3          # delete day 1, 2 and 3 from the current month and year',
                'work-md d -d=1,2 -m=4       # delete day 1 and 2 from month 4 and current year',
                'work-md d -d=1..10 -m=4     # delete day 1 to 10 from month 4 and current year',
                'work-md d -d=1..25 -m=2 and -d=1..25 -m=2 -y=1999     # delete day 1 to 25 from month 2 and current year and 1 to 25 from month 2 in 1999',
                **Work::Md::Cli.error_frame_style
              )
            )
          end
        end
      end
    end
  end
end
