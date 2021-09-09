# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Tyesterday
        class << self
          def execute(_argv = [])
            file_names =
              [DateTime.now, Date.today.prev_day].map do |date|
                Work::Md::File.create_if_not_exist(date)
              end

            Work::Md::File.open_in_editor(file_names)
          end
        end
      end
    end
  end
end
