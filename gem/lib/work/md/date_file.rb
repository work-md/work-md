# frozen_string_literal: true

module Work
  module Md
    class DateFile
      def self.open_or_create(some_date, dir: nil)
        Work::Md::File.open_in_editor(
          [create_if_not_exist(some_date, dir: dir)], dir: dir
        )
      end

      def self.list_file_names_by_argv_query(argv)
        file_names = []

        argv_keys_to_files = -> (argv_keys, acc_file_names) {
          year = argv_keys['y'] || Time.new.year
          month = argv_keys['m'] || Time.new.month

          month = "0#{month.to_i}" if month.to_i < 10

          add_file_to_open = lambda do |day|
            day = "0#{day.to_i}" if day.to_i < 10

            file_name = Work::Md::Config.work_dir + "/#{year}/#{month}/#{day}.md"

            acc_file_names.push(file_name) if ::File.exist? file_name
          end

          if argv_keys['d'].include?('..')
            range = argv_keys['d'].split('..')

            (range[0].to_i..range[1].to_i).each { |day| add_file_to_open.call(day) }
          else
            argv_keys['d'].split(',').each { |day| add_file_to_open.call(day) }
          end

          acc_file_names
        }

        argv.join('#').split('#and#').map { |v| v.split("#") }.each do |args|
          argv_keys_to_files.(Work::Md::Cli.fetch_argv_keys(args), file_names)
        end

        file_names
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
