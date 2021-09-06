# frozen_string_literal: true

module Work
  module Md
    module Commands
      class Today
        class << self
          def execute(_argv = [])
            Work::Md::File.open_or_create(DateTime.now)
          end
        end
      end
    end
  end
end
