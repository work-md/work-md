# frozen_string_literal: true

# TODO: Make this a class with receive an yaml file directory,
# this is easier to mock in test
# TODO: Set language (i18n) as a config
module WorkMd
  module Config
    TRANSLATIONS = {
      'pt' =>
        {
          tasks: 'Atividades',
          meetings: 'Reuniões',
          annotations: 'Anotações',
          meeting_annotations: 'Anotações de Reunião',
          interruptions: 'Interrupções',
          difficulties: 'Dificuldades',
          pomodoros: 'Pomodoros'
        },
      'en' =>
        {
          tasks: 'Tasks',
          meetings: 'Meetings',
          annotations: 'Annotations',
          meeting_annotations: 'Meeting Annotations',
          interruptions: 'Interruptions',
          difficulties: 'Difficulties',
          pomodoros: 'Pomodoros'
        }
    }.freeze

    def self.editor
      ENV['EDITOR'] || ENV['VISUAL'] || 'vi'
    end

    def self.work_dir
      ENV['WORK_MD_DIR'] || "#{Dir.home}/work_md"
    end

    def self.translations
      TRANSLATIONS[ENV['WORK_MD_LANG']] || TRANSLATIONS['en']
    end
  end
end
