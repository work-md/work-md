# frozen_string_literal: true

module WorkMd
  module Commands
    class Parse
      PARSED_FILE_PATH = WorkMd::Config.work_dir + '/parsed.md'

      class << self
        def execute(argv = [])
          args = Hash[argv.join(' ').scan(/-?([^=\s]+)(?:=(\S+))?/)]
          parser = WorkMd::Parser::Engine.new
          t = WorkMd::Config.translations

          year = args['y'] || Time.new.year
          month = args['m'] || Time.new.month

          month = "0#{month.to_i}" if month.to_i < 10

          args['d'].split(',').each do |day|
            day = "0#{day.to_i}" if day.to_i < 10

            file_name = WorkMd::Config.work_dir + "/#{year}/#{month}/#{day}.md"

            parser.add_file(file_name)
          end

          parser.freeze

          File.delete(PARSED_FILE_PATH) if File.exist? PARSED_FILE_PATH

          File.open(PARSED_FILE_PATH, 'w+') do |f|
            f.puts("# #{args.inspect}\n\n")
            f.puts("### #{t[:tasks]}:\n\n")
            parser.tasks.each do |task|
              f.puts("- [#{task}\n\n") if task != ' ]'
            end
            f.puts("---\n\n")
            f.puts("### #{t[:meetings]}:\n\n")
            parser.meetings.each do |meeting|
              f.puts("- #{meeting}\n\n")
            end
            f.puts("---\n\n")
            f.puts("### #{t[:annotations]}:\n\n")
            parser.annotations.each do |annotation|
              f.puts("- #{annotation.gsub('###', '')}") unless annotation.nil?
            end
            f.puts("###### #{t[:meeting_annotations]}:\n\n")
            parser.meeting_annotations.each do |meeting_annotation|
              f.puts("- #{meeting_annotation}\n\n")
            end
            f.puts("---\n\n")
            f.puts("### #{t[:interruptions]}:\n\n")
            parser.interruptions.each do |interruption|
              f.puts("- #{interruption}\n\n")
            end
            f.puts("---\n\n")
            f.puts("### #{t[:difficulties]}:\n\n")
            parser.difficulties.each do |difficulty|
              f.puts("- #{difficulty}\n\n")
            end
            f.puts("---\n\n")
            f.puts("### #{t[:pomodoros]}:\n\n")
            f.puts(parser.pomodoros)
          end

          system("#{WorkMd::Config.editor} #{PARSED_FILE_PATH}")
        end
      end
    end
  end
end