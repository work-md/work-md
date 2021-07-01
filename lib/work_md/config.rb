# frozen_string_literal: true

# TODO:
# 1. Make this a class with receive an yaml file directory, this is easier to mock in test
# 2. Set language as a config
module WorkMd
  module Config
    def self.editor
      ENV['EDITOR'] || 'vim'
    end

    def self.work_dir
      "#{Dir.home}/work_md/"
    end
  end
end
