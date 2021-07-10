# frozen_string_literal: true

# TODO: Make this a class with receive an yaml file directory,
# this is easier to mock in test
# TODO: Set language (i18n) as a config
module WorkMd
  module Config
    def self.editor
      ENV['EDITOR']
    end

    def self.work_dir
      "#{Dir.home}/work_md/"
    end

    def self.translations
      {
        tasks: 'Atividades',
        meetings: 'Reuniões',
        annotations: 'Anotações',
        meeting_annotations: 'Anotações de Reunião',
        interruptions: 'Interrupções',
        difficulties: 'Dificuldades',
        pomodoros: 'Pomodoros',
        point: 'Ponto'
      }
    end
  end
end
