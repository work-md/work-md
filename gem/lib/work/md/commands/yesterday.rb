# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Yesterday
        class << self
          def execute(_argv = [])
            Work::Md::File.open_or_create(Date.today.prev_day)
          end
        end
      end
    end
  end
end
