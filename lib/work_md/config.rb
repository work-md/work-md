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
      "#{Dir.home}/work_md"
    end

    def self.translations
      {
        tasks: 'Tasks',
        meetings: 'Meetings',
        annotations: 'Annotations',
        meeting_annotations: 'Meeting Annotations',
        interruptions: 'Interruptions',
        difficulties: 'Difficulties',
        pomodoros: 'Pomodoros'
      }
    end
  end
end
