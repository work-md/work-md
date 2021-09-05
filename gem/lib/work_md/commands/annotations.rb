# frozen_string_literal: true

module WorkMd
  module Commands
    class Annotations
      class << self
        def execute(_argv = [])
          file_name = "annotations.md"
          work_dir = WorkMd::Config.work_dir

          ::FileUtils.mkdir_p("#{work_dir}")

          unless ::File.exist?("#{work_dir}/#{file_name}")
            ::File.open("#{work_dir}/#{file_name}", 'w+') { |f| f.puts("# \n\n") }
          end

          WorkMd::File.open_in_editor([file_name])
        end
      end
    end
  end
end
