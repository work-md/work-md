# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Daily
        class << self
          def execute(_argv = [])
            last_date = Date.today.prev_day
            work_dir = Work::Md::Config.work_dir
            last_file_name = nil

            (1..160).each do
              last_file_name = "#{last_date.strftime('%Y/%m/%d')}.md"
              break if ::File.exist?("#{work_dir}/#{last_file_name}")

              last_date = last_date.prev_day
            end

            today_file_name = Work::Md::DateFile.create_if_not_exist(DateTime.now)

            parser_today = Work::Md::Parser::Engine.new
            parser_today.add_file("#{work_dir}/#{today_file_name}")
            parser_today.freeze

            parser_last_day = Work::Md::Parser::Engine.new
            parser_last_day.add_file("#{work_dir}/#{last_file_name}")
            parser_last_day.freeze

            daily_file_path = work_dir + '/daily.md'
            ::File.delete(daily_file_path) if ::File.exist? daily_file_path

            t = Work::Md::Config.translations

            ajust_line = lambda do |line|
              get_first_line = ->(multiline_string) do
                lines = multiline_string.split("\n")
                first_line = lines.first
                return first_line
              end

              get_first_line.call(line.sub('x]', '-').sub(']', '-'))
            end

            ::File.open(daily_file_path, 'w+') do |f|
              f.puts("📅 Daily\n\n")
              f.puts("#{t[:did]}:\n")
              parser_last_day.tasks.each do |task|
                f.puts("#{ajust_line.call(task)}\n") if task != ' ]'
              end
              parser_last_day.meetings.each do |meeting|
                f.puts("#{ajust_line.call(meeting)}\n") if meeting != ' ]'
              end
              f.puts("\n")
              f.puts("#{t[:todo]}:\n")
              parser_today.tasks.each do |task|
                f.puts("#{ajust_line.call(task)}\n") if task != ' ]'
              end
              parser_today.meetings.each do |meeting|
                f.puts("#{ajust_line.call(meeting)}\n") if meeting != ' ]'
              end
            end

            Work::Md::File.open_in_editor([daily_file_path])
          end
        end
      end
    end
  end
end
