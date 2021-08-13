# frozen_string_literal: true

require 'byebug'

module WorkMd
  class File
    def self.open_or_create(some_date)
      open_in_editor(create_if_not_exist(some_date))
    end

    def self.create_if_not_exist(some_date)
      t = WorkMd::Config.translations
      work_dir = WorkMd::Config.work_dir

      ::FileUtils
        .mkdir_p("#{work_dir}/#{some_date.strftime('%Y/%m')}")

      filename = "#{some_date.strftime('%Y/%m/%d')}.md"

      return filename if ::File.exist?("#{work_dir}/#{filename}")

      ::File.open(
        "#{work_dir}/#{filename}",
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

      filename
    end

    def self.open_in_editor(filename1, filename2 = nil)
      editor = WorkMd::Config.editor

      ::FileUtils.cd(WorkMd::Config.work_dir) do
        ENV['EDITOR'] = editor unless editor.nil?

        return ::TTY::Editor.open(filename1) if filename2.nil?

        ::TTY::Editor.open(filename1, filename2)
      end
    end
  end
end
