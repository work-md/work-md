# frozen_string_literal: true

module Work
  module Md
    class File
      def self.open_in_editor(file_names = [], dir: nil)
        editor = Work::Md::Config.editor
        work_dir = dir || Work::Md::Config.work_dir

        ::FileUtils.cd(work_dir) do
          ENV['EDITOR'] = editor unless editor.nil?

          return ::TTY::Editor.open(file_names[0]) if file_names[1].nil?

          ::TTY::Editor.open(file_names[0], file_names[1])
        end
      end
    end
  end
end
