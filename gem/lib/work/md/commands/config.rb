# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Config
        class << self
          def execute(_argv = [])
            file_name = 'config.yml'
            work_dir = ::Work::Md::Config::DEFAULT_WORK_DIR

            unless ::File.exist?("#{work_dir}/#{file_name}")
              ::FileUtils.mkdir_p(work_dir)

              ::File.open("#{work_dir}/#{file_name}", 'w+') do |f|
                f.puts('# Example configuration:')
                f.puts('#')
                f.puts('# title: Your Name')
                f.puts('# editor: vim')
                f.puts('# lang: en')
                f.puts('#')
                f.puts('title: # Title your work-md files')
                f.puts('editor: # Your default editor')
                f.puts("lang: # Only 'pt', 'en' and 'es' avaiable")
              end
            end

            ::Work::Md::File.open_in_editor(
              [file_name],
              dir: work_dir
            )
          end
        end
      end
    end
  end
end
