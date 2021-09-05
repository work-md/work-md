# frozen_string_literal: true

module WorkMd
  class File
    def self.open_or_create(some_date, dir: nil)
      open_in_editor([create_if_not_exist(some_date, dir: dir)], dir: dir)
    end

    def self.create_if_not_exist(some_date, dir: nil)
      t = WorkMd::Config.translations
      work_dir = dir || WorkMd::Config.work_dir

      file_name = "#{some_date.strftime('%Y/%m/%d')}.md"

      return file_name if ::File.exist?("#{work_dir}/#{file_name}")

      ::FileUtils
        .mkdir_p("#{work_dir}/#{some_date.strftime('%Y/%m')}")

      ::File.open(
        "#{work_dir}/#{file_name}",
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

      file_name
    end

    def self.open_in_editor(file_names = [], dir: nil)
      editor = WorkMd::Config.editor
      work_dir = dir || WorkMd::Config.work_dir

      ::FileUtils.cd(work_dir) do
        ENV['EDITOR'] = editor unless editor.nil?

        return ::TTY::Editor.open(file_names[0]) if file_names[1].nil?

        ::TTY::Editor.open(file_names[0], file_names[1])
      end
    end
  end
end
