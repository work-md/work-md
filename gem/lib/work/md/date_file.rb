# frozen_string_literal: true

module Work
  module Md
    class DateFile
      def self.open_or_create(some_date, dir: nil)
        Work::Md::File.open_in_editor(
          [create_if_not_exist(some_date, dir: dir)], dir: dir
        )
      end

      def self.create_if_not_exist(some_date, dir: nil)
        t = Work::Md::Config.translations
        work_dir = dir || Work::Md::Config.work_dir

        file_name = "#{some_date.strftime('%Y/%m/%d')}.md"

        return file_name if ::File.exist?("#{work_dir}/#{file_name}")

        ::FileUtils
          .mkdir_p("#{work_dir}/#{some_date.strftime('%Y/%m')}")

        ::File.open(
          "#{work_dir}/#{file_name}",
          'w+'
        ) do |f|
          f.puts("# #{some_date.strftime('%d/%m/%Y')} - #{Work::Md::Config.title} \n\n")
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
    end
  end
end
