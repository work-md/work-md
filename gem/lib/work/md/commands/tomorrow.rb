# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Tomorrow
        class << self
          def execute(_argv = [])
            Work::Md::DateFile.open_or_create(Date.today.next_day)
          end
        end
      end
    end
  end
end
