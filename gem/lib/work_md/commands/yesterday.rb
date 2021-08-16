# frozen_string_literal: true

module WorkMd
  module Commands
    class Yesterday
      class << self
        def execute(_argv = [])
          WorkMd::File.open_or_create(Date.today.prev_day)
        end
      end
    end
  end
end
