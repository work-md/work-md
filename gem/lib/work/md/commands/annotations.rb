# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Annotations
        class << self
          def execute(_argv = [])
            file_name = 'annotations.md'
            work_dir = Work::Md::Config.work_dir

            ::FileUtils.mkdir_p(work_dir.to_s)

            unless ::File.exist?("#{work_dir}/#{file_name}")
              ::File.open("#{work_dir}/#{file_name}", 'w+') { |f| f.puts("# \n\n") }
            end

            Work::Md::File.open_in_editor([file_name])
          end
        end
      end
    end
  end
end
