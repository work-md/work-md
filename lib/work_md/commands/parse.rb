# frozen_string_literal: true

module WorkMd
  module Commands
    class Parse
      PARSED_FILE_PATH = WorkMd::Config.work_dir + '/parsed.md'

      class << self
        def execute(argv = [])
          begin
            args = Hash[argv.join(' ').scan(/-?([^=\s]+)(?:=(\S+))?/)]
            parser = WorkMd::Parser::Engine.new
            t = WorkMd::Config.translations

            year = args['y'] || Time.new.year
            month = args['m'] || Time.new.month

            month = "0#{month.to_i}" if month.to_i < 10
            #add_file_to_parser = ->(day) do
              #day = "0#{day.to_i}" if day.to_i < 10

              #file_name = WorkMd::Config.work_dir + "/#{year}/#{month}/#{day}.md"

              #parser.add_file(file_name)
            #end

            #if args['d'].match('..')
              #range = args['d'].split('..')

              #(range[0].to_i..range[1].to_i).each { |day| add_file_to_parser.(day) }
            #elsif
              #args['d'].split(',').each { |day| add_file_to_parser.(day) }
            #end

            args['d'].split(',').each do |day|
              day = "0#{day.to_i}" if day.to_i < 10

              file_name = WorkMd::Config.work_dir + "/#{year}/#{month}/#{day}.md"

              parser.add_file(file_name)
            end

            parser.freeze

            ::File.delete(PARSED_FILE_PATH) if ::File.exist? PARSED_FILE_PATH

            ::File.open(PARSED_FILE_PATH, 'w+') do |f|
              f.puts("# #{WorkMd::Config.title}\n\n")
              f.puts("### #{t[:tasks]} (#{parser.tasks.size}):\n\n")
              parser.tasks.each do |task|
                f.puts("- [#{task}\n\n") if task != ' ]'
              end
              f.puts("---\n\n")
              f.puts("### #{t[:meetings]} (#{parser.meetings.size}):\n\n")
              parser.meetings.each do |meeting|
                f.puts("- [#{meeting}\n\n") if meeting != ' ]'
              end
              f.puts("---\n\n")
              f.puts("### #{t[:interruptions]} (#{parser.interruptions.size}):\n\n")
              parser.interruptions.each do |interruption|
                f.puts("- #{interruption}\n\n")
              end
              f.puts("---\n\n")
              f.puts("### #{t[:difficulties]} (#{parser.difficulties.size}):\n\n")
              parser.difficulties.each do |difficulty|
                f.puts("- #{difficulty}\n\n")
              end
              f.puts("---\n\n")
              f.puts("### #{t[:observations]} (#{parser.observations.size}):\n\n")
              parser.observations.each do |observation|
                f.puts("- #{observation}\n\n")
              end
              f.puts("---\n\n")
              f.puts("### #{t[:pomodoros]} (#{parser.average_pomodoros} #{t[:per_day]}):\n\n")
              f.puts(parser.pomodoros)
            end

            editor = WorkMd::Config.editor

            unless editor.nil?
              ::TTY::Editor.open(PARSED_FILE_PATH, command: editor)
            else
              ::TTY::Editor.open(PARSED_FILE_PATH)
            end
          rescue => e
            WorkMd::Cli.info(
              ::TTY::Box.frame(
                "message: #{e.message}",
                "",
                "Usage examples:",
                "",
                "work_md parse -d=1 -m=5 -y=2000 | get day 1 from month 5 and year 2000",
                "work_md parse -d=1,2,3          | get day 1, 2 and 3 from the current month and year",
                "work_md parse -d=1,2 -m=4       | get day 1 and 2 from month 4 and current year",
                **WorkMd::Cli.error_frame_style
              )
            )
          end
        end
      end
    end
  end
end
