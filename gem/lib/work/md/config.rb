# frozen_string_literal: true

require 'yaml'

module Work
  module Md
    module Config
      DEFAULT_WORK_DIR = "#{Dir.home}/work-md"
      TRANSLATIONS = {
        'pt' =>
          {
            tasks: 'Atividades',
            meetings: 'Reuniões',
            interruptions: 'Interrupções',
            difficulties: 'Dificuldades',
            observations: 'Observações',
            pomodoros: 'Pomodoros / Ciclos',
            per_day: 'por dia',
            total: 'total',
            days_bars: 'Resumo',
            did: 'Feito',
            todo: 'Planejado'
          },
        'en' =>
          {
            tasks: 'Tasks',
            meetings: 'Meetings',
            interruptions: 'Interruptions',
            difficulties: 'Difficulties',
            observations: 'Observations',
            pomodoros: 'Pomodoros / Cycles',
            per_day: 'per day',
            total: 'all',
            days_bars: 'Summary',
            did: 'Done',
            todo: 'To do'
          },
        'es' =>
          {
            tasks: 'Tareas',
            meetings: 'Reuniones',
            interruptions: 'Interrupciones',
            difficulties: 'Dificultades',
            observations: 'Observaciones',
            pomodoros: 'Pomodoros / Ciclos',
            per_day: 'por día',
            total: 'total',
            days_bars: 'Abstracto',
            did: 'Hecho',
            todo: 'Planificado'
          }
      }.freeze

      def self.title
        yaml_file['title'] || ''
      end

      def self.editor
        ENV['EDITOR'] || ENV['VISUAL'] || yaml_file['editor'] || nil
      end

      def self.work_dir
        dir =
          ENV['WORK_MD_DIR'] || DEFAULT_WORK_DIR

        return "#{dir}/#{ENV['WORK_MD_TAG']}" if ENV['WORK_MD_TAG']

        dir
      end

      def self.translations
        TRANSLATIONS[ENV['WORK_MD_LANG']] ||
          TRANSLATIONS[yaml_file['lang']] ||
          TRANSLATIONS['en']
      end

      def self.yaml_file
        YAML.load_file("#{DEFAULT_WORK_DIR}/config.yml")
      rescue StandardError
        {}
      end
    end
  end
end
