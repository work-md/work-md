# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Tlast
        class << self
          def execute(_argv = [])
            last_date = Date.today.prev_day
            work_dir = Work::Md::Config.work_dir
            last_file_name = nil

            (1..90).each do
              last_file_name = "#{last_date.strftime('%Y/%m/%d')}.md"
              break if ::File.exist?("#{work_dir}/#{last_file_name}")

              last_date = last_date.prev_day
            end

            today_file_name = Work::Md::DateFile.create_if_not_exist(DateTime.now)

            Work::Md::File.open_in_editor([today_file_name, last_file_name].compact)
          end
        end
      end
    end
  end
end
