# frozen_string_literal: true

module WorkMd
  module Commands
    class Tyesterday
      class << self
        def execute(_argv = [])
          [DateTime.now, Date.today.prev_day].each do |date|
            WorkMd::File.create_if_not_exist(date)
            WorkMd::File.open_in_editor(date)
          end
        end
      end
    end
  end
end
