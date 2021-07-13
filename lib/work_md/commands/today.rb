# frozen_string_literal: true

module WorkMd
  module Commands
    class Today
      class << self
        def execute(_argv = [])
          today = DateTime.now
          t = WorkMd::Config.translations
          work_dir = WorkMd::Config.work_dir

          ::FileUtils
            .mkdir_p("#{work_dir}/#{today.strftime('%Y/%m')}")
          unless ::File
                 .exist?(
                   "#{work_dir}/#{today.strftime('%Y/%m/%d')}.md"
                 )
            ::File.open(
              "#{work_dir}/#{today.strftime('%Y/%m/%d')}.md",
              'w+'
            ) do |f|
              f.puts("# #{today.strftime('%d/%m/%Y')} - #{WorkMd::Config.title} \n\n")
              f.puts("### #{t[:tasks]}:\n\n")
              f.puts("- [ ]\n\n")
              f.puts("---\n\n")
              f.puts("### #{t[:meetings]}:\n\n")
              f.puts("---\n\n")
              f.puts("### #{t[:annotations]}:\n\n")
              f.puts("###### #{t[:meeting_annotations]}:\n\n")
              f.puts("---\n\n")
              f.puts("### #{t[:interruptions]}:\n\n")
              f.puts("---\n\n")
              f.puts("### #{t[:difficulties]}:\n\n")
              f.puts("---\n\n")
              f.puts("### #{t[:pomodoros]}:\n\n")
              f.puts("0\n\n")
            end
          end

          editor = WorkMd::Config.editor

          ::FileUtils.cd(work_dir) do
            unless editor.nil?
              ::TTY::Editor.open(
                "#{today.strftime('%Y/%m/%d')}.md",
                {command: editor}
              )
            else
              ::TTY::Editor.open("#{today.strftime('%Y/%m/%d')}.md")
            end
          end
        end
      end
    end
  end
end
