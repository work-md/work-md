# frozen_string_literal: true

module WorkMd
  module Commands
    class Tyesterday
      class << self
        def execute(_argv = [])
          filenames =
            [DateTime.now, Date.today.prev_day].map do |date|
              WorkMd::File.create_if_not_exist(date)
            end

          WorkMd::File.open_in_editor(filenames[0], filenames[1])
        end
      end
    end
  end
end
