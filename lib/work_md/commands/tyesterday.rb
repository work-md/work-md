# frozen_string_literal: true

module WorkMd
  module Commands
    class Tyesterday
      class << self
        def execute(_argv = [])
          WorkMd::File.open_or_create(DateTime.now)
          WorkMd::File.open_or_create(Date.today.prev_day)
        end
      end
    end
  end
end
