# frozen_string_literal: true

module Work
  module Md
    class File
      def self.open_in_editor(file_names = [], dir: nil)
        editor = Work::Md::Config.editor
        work_dir = dir || Work::Md::Config.work_dir

        ::FileUtils.cd(work_dir) do
          ENV['EDITOR'] = editor unless editor.nil?

          return ::TTY::Editor.open(file_names[0]) if file_names[1].nil?

          ::TTY::Editor.open(file_names[0], file_names[1])
        end
      end

      def self.create_and_open_parsed(parser)
        parser.freeze

        parsed_file_path = Work::Md::Config.work_dir + '/parsed.md'
        t = Work::Md::Config.translations

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
          f.puts("\n") if parser.interruptions.size.positive?
          f.puts("---\n\n")
          f.puts("### #{t[:difficulties]} (#{parser.difficulties.size}):\n\n")
          parser.difficulties.each do |difficulty|
            f.puts("- #{difficulty}\n")
          end
          f.puts("\n") if parser.difficulties.size.positive?
          f.puts("---\n\n")
          f.puts("### #{t[:observations]} (#{parser.observations.size}):\n\n")
          parser.observations.each do |observation|
            f.puts("- #{observation}\n")
          end
          f.puts("\n") if parser.observations.size.positive?
          f.puts("---\n\n")
          f.puts("### #{t[:pomodoros]} (#{parser.average_pomodoros} #{t[:per_day]}):\n\n")
          f.puts("**#{t[:total]}: #{parser.pomodoros_sum}**")
          f.puts("\n")
          parser.pomodoros_bars.each do |pomodoro_bar|
            f.puts(pomodoro_bar)
            f.puts("\n")
          end
          f.puts("---\n\n")
          f.puts("### #{t[:days_bars]}:\n\n")
          f.puts("**#{t[:pomodoros]}: ⬛ | #{t[:meetings]}: 📅 | #{t[:interruptions]}: ⚠️ | #{t[:difficulties]}: 😓 | #{t[:observations]}: 📝 | #{t[:tasks]}: ✔️**")

          f.puts("\n")
          parser.days_bars.each do |day_bar|
            f.puts(day_bar)
            f.puts("\n")
          end

          f.puts("\n\n")

          Work::Md::File.open_in_editor([parsed_file_path])
        end
      end
    end
  end
end
