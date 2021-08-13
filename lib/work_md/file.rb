# frozen_string_literal: true

module WorkMd
  class File
    def self.open_or_create(some_date)
      create_if_not_exist(some_date)
      open_in_editor(some_date)
    end

    def self.create_if_not_exist(some_date)
      t = WorkMd::Config.translations
      work_dir = WorkMd::Config.work_dir

      ::FileUtils
        .mkdir_p("#{work_dir}/#{some_date.strftime('%Y/%m')}")

      if ::File.exist?("#{work_dir}/#{some_date.strftime('%Y/%m/%d')}.md")
        return
      end

      ::File.open(
        "#{work_dir}/#{some_date.strftime('%Y/%m/%d')}.md",
        'w+'
      ) do |f|
        # rubocop:disable Layout/LineLength
        f.puts("# #{some_date.strftime('%d/%m/%Y')} - #{WorkMd::Config.title} \n\n")
        # rubocop:enable Layout/LineLength
        f.puts("### #{t[:tasks]}:\n\n")
        f.puts("- [ ]\n\n")
        f.puts("---\n\n")
        f.puts("### #{t[:meetings]}:\n\n")
        f.puts("- [ ]\n\n")
        f.puts("---\n\n")
        f.puts("### #{t[:interruptions]}:\n\n")
        f.puts("---\n\n")
        f.puts("### #{t[:difficulties]}:\n\n")
        f.puts("---\n\n")
        f.puts("### #{t[:observations]}:\n\n")
        f.puts("---\n\n")
        f.puts("### #{t[:pomodoros]}:\n\n")
        f.puts("0\n\n")
      end
    end

    def self.open_in_editor(some_date)
      work_dir = WorkMd::Config.work_dir
      editor = WorkMd::Config.editor

      ::FileUtils.cd(work_dir) do
        if editor.nil?
          ::TTY::Editor.open("#{some_date.strftime('%Y/%m/%d')}.md")
        else
          ::TTY::Editor.open(
            "#{some_date.strftime('%Y/%m/%d')}.md",
            command: editor
          )
        end
      end
    end
  end
end
