# frozen_string_literal: true

require 'yaml'

module WorkMd
  module Config
    DEFAULT_WORK_DIR = Dir.home + '/work_md'
    YAML_FILE = YAML.load_file(DEFAULT_WORK_DIR + '/config.yml')
    DEFAULT_EDITOR = 'vi'
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

    def self.title
      YAML_FILE['title']
    end

    def self.editor
      ENV['EDITOR'] || ENV['VISUAL'] || YAML_FILE['editor'] || DEFAULT_EDITOR
    end

    def self.work_dir
      ENV['WORK_MD_DIR'] || DEFAULT_WORK_DIR
    end

    def self.translations
      TRANSLATIONS[ENV['WORK_MD_LANG']] ||
        TRANSLATIONS[YAML_FILE['lang']] ||
        TRANSLATIONS['en']
    end
  end
end
