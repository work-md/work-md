# frozen_string_literal: true

require 'byebug'

module Work
  module Md
    module Commands
      class Parse
        class << self
          def execute(argv = [])
            parsed_file_path = Work::Md::Config.work_dir + '/parsed.md'
            t = Work::Md::Config.translations

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

            parser.freeze

            ::File.delete(parsed_file_path) if ::File.exist? parsed_file_path

            ::File.open(parsed_file_path, 'w+') do |f|
              f.puts("# #{Work::Md::Config.title}\n\n")
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
                f.puts("- #{interruption}\n")
              end
              f.puts("---\n\n")
              f.puts("### #{t[:difficulties]} (#{parser.difficulties.size}):\n\n")
              parser.difficulties.each do |difficulty|
                f.puts("- #{difficulty}\n")
              end
              f.puts("---\n\n")
              f.puts("### #{t[:observations]} (#{parser.observations.size}):\n\n")
              parser.observations.each do |observation|
                f.puts("- #{observation}\n")
              end
              f.puts("---\n\n")
              f.puts("### #{t[:pomodoros]} (#{parser.average_pomodoros} #{t[:per_day]}):\n\n")
              f.puts("**#{t[:total]}: #{parser.pomodoros_sum}**")
              f.puts("\n\n")
              parser.pomodoros_bars.each do |pomodoro_bar|
                f.puts(pomodoro_bar)
                f.puts("\n\n")
              end
              f.puts("---\n\n")
              f.puts("### #{t[:days_bars]}:\n\n")
              f.puts("**#{t[:pomodoros]}: ⬛ | #{t[:meetings]}: 📅 | #{t[:interruptions]}: ⚠️ | #{t[:difficulties]}: 😓 | #{t[:observations]}: 📝 | #{t[:tasks]}: ✔️**")

              f.puts("\n\n")
              parser.days_bars.each do |day_bar|
                f.puts(day_bar)
                f.puts("\n\n")
              end

              f.puts("\n\n")
            end

            editor = Work::Md::Config.editor

            if editor.nil?
              ::TTY::Editor.open(parsed_file_path)
            else
              ::TTY::Editor.open(parsed_file_path, command: editor)
            end
          rescue StandardError => e
            Work::Md::Cli.help(
              ::TTY::Box.frame(
                "message: #{e.message}",
                '',
                'Usage examples:',
                '',
                'work-md parse -d=1 -m=5 -y=2000 | get day 1 from month 5 and year 2000',
                'work-md parse -d=1,2,3          | get day 1, 2 and 3 from the current month and year',
                'work-md parse -d=1,2 -m=4       | get day 1 and 2 from month 4 and current year',
                'work-md parse -d=1..10 -m=4     | get day 1 to 10 from month 4 and current year',
                **Work::Md::Cli.error_frame_style
              )
            )
          end
        end
      end
    end
  end
end
