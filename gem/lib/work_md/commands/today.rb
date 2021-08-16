# frozen_string_literal: true

module WorkMd
  module Commands
    class Today
      class << self
        def execute(_argv = [])
          WorkMd::File.open_or_create(DateTime.now)
        end
      end
    end
  end
end
