# frozen_string_literal: true

module WorkMd
  module Commands
    class Tyesterday
      class << self
        def execute(_argv = [])
          file_names =
            [DateTime.now, Date.today.prev_day].map do |date|
              WorkMd::File.create_if_not_exist(date)
            end

          WorkMd::File.open_in_editor(file_names: file_names)
        end
      end
    end
  end
end
