# frozen_string_literal: true

module Work
  module Md
    class DateFile
      def self.open_or_create(some_date)
        Work::Md::File.open_in_editor(
          [create_if_not_exist(some_date)]
        )
      end

      def self.list_file_paths_by_argv_query(argv, create_inexistent: false)
        file_paths = []

        argv_keys_to_files = lambda { |argv_keys, acc_file_paths|
          year = argv_keys['y'] || Time.new.year
          month = argv_keys['m'] || Time.new.month

          month = "0#{month.to_i}" if month.to_i < 10

          add_file_to_acc = lambda do |day|
            day = "0#{day.to_i}" if day.to_i < 10

            file_path = Work::Md::Config.work_dir + "/#{year}/#{month}/#{day}.md"

            if create_inexistent
              create_if_not_exist(DateTime.new(year.to_i, month.to_i, day.to_i))

              acc_file_paths.push(file_path)
            elsif ::File.exist? file_path
              acc_file_paths.push(file_path)
            end
          end

          if argv_keys['d'].include?('..')
            range = argv_keys['d'].split('..')

            (range[0].to_i..range[1].to_i).each { |day| add_file_to_acc.call(day) }
          else
            argv_keys['d'].split(',').each { |day| add_file_to_acc.call(day) }
          end

          acc_file_paths
        }

        argv.join('#').split('#and#').map { |v| v.split('#') }.each do |args|
          argv_keys_to_files.call(Work::Md::Cli.fetch_argv_keys(args), file_paths)
        end

        file_paths
      end

      def self.create_if_not_exist(some_date)
        t = Work::Md::Config.translations
        file = date_to_file_locations(some_date)
        return file[:name] if ::File.exist?(file[:path])

        ::FileUtils
          .mkdir_p(file[:dir])

        ::File.open(
          file[:path],
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

        file[:name]
      end

      def self.date_to_file_locations(some_date)
        work_dir = Work::Md::Config.work_dir

        {
          name: "#{some_date.strftime('%Y/%m/%d')}.md",
          dir: "#{work_dir}/#{some_date.strftime('%Y/%m')}",
          path: "#{work_dir}/#{some_date.strftime('%Y/%m/%d')}.md"
        }
      end
    end
  end
end
