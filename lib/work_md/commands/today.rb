# frozen_string_literal: true

module WorkMd
  module Commands
    class Today
      class << self
        def description; end

        def execute(argv = [], options = {})
          today = options[:today] || DateTime.now

          ::FileUtils.mkdir_p("#{WorkMd::Config.work_dir}/#{today.strftime('%Y/%m')}")
          unless ::File.exist?("#{WorkMd::Config.work_dir}/#{today.strftime('%Y/%m/%d')}.md")
            ::File.open("#{WorkMd::Config.work_dir}/#{today.strftime('%Y/%m/%d')}.md", 'w+') do |f|
              f.puts("# #{today.strftime('%d/%m/%Y')} \n\n")
              f.puts("### Atividades:\n\n")
              f.puts("- [ ]\n\n")
              f.puts("---\n\n")
              f.puts("### Reuniões:\n\n")
              f.puts("---\n\n")
              f.puts("### Anotações:\n\n")
              f.puts("###### Anotações de Reunião:\n\n")
              f.puts("---\n\n")
              f.puts("### Interrupções:\n\n")
              f.puts("---\n\n")
              f.puts("### Dificuldades:\n\n")
              f.puts("---\n\n")
              f.puts("### Pomodoros:\n\n")
              f.puts("0\n\n")
              f.puts("---\n\n")
              f.puts("### Ponto:\n\n")
              f.puts("- \n\n")
            end
          end

          ::FileUtils.cd(WorkMd::Config.work_dir) do
            system("#{WorkMd::Config.editor} #{today.strftime('%Y/%m/%d')}.md")
          end

          exit
        end
      end
    end
  end
end
