# frozen_string_literal: true

module WorkMd
  module Parser
    class Engine
      IS_FROZEN_ERROR_MESSAGE = 'WorkMd::Parser::Engine is frozen'
      IS_NOT_FROZEN_ERROR_MESSAGE = 'WorkMd::Parser::Engine is not frozen'

      class ParsedFile
        attr_accessor :tasks,
                      :annotations,
                      :meeting_annotations,
                      :meetings,
                      :interruptions,
                      :difficulties,
                      :pomodoros
      end

      def initialize
        @t = WorkMd::Config.translations
        @parsed_files = []
        @frozen = false
      end

      def add_file(file)
        raise IS_FROZEN_ERROR_MESSAGE if @frozen

        # TODO: Write tests for this behaviour
        begin
          file_content = File.read(file)
        rescue Errno::ENOENT
          return
        end

        return unless file_content.start_with?('# ')

        @parsed_files.push(parse_file_content(file_content))
      end

      def done_tasks
        raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

        @done_tasks ||=
          tasks.filter { |t| t.start_with?('x]') || t.start_with?('X]') }
      end

      def tasks
        raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

        @tasks ||= @parsed_files.map(&:tasks).flatten
      end

      def annotations
        raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

        @annotations ||= @parsed_files.map(&:annotations).flatten
      end

      def meeting_annotations
        raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

        @meeting_annotations ||=
          @parsed_files.map(&:meeting_annotations).flatten
      end

      def meetings
        raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

        @meetings ||= @parsed_files.map(&:meetings).flatten
      end

      def interruptions
        raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

        @interruptions ||= @parsed_files.map(&:interruptions).flatten
      end

      def difficulties
        raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

        @difficulties ||= @parsed_files.map(&:difficulties).flatten
      end

      def pomodoros
        raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

        @pomodoros ||=
          @parsed_files.reduce(0) { |sum, f| sum + f.pomodoros || 0 }
      end

      def freeze
        @frozen = true
      end

      private

      # TODO: Refactor this method
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def parse_file_content(file_content)
        parsed_file = ParsedFile.new

        contents_by_title = file_content.split('### ')

        contents_by_title.each do |content|
          if content.start_with?(@t[:tasks])
            parsed_file.tasks =
              clear_list(content.split(":\n\n")[1].split('- ['))
          elsif content.start_with?(@t[:meetings])
            parsed_file.meetings =
              clear_list(content.split(":\n\n")[1].split('- '))
          elsif content.start_with?(@t[:meeting_annotations])
            parsed_file.meeting_annotations =
              clear_list(content.split(":\n\n")[1])
          elsif content.start_with?(@t[:annotations])
            parsed_file.annotations =
              clear_list(content.split(":\n\n")[1])
          elsif content.start_with?(@t[:interruptions])
            parsed_file.interruptions =
              clear_list(content.split(":\n\n")[1].split('- '))
          elsif content.start_with?(@t[:difficulties])
            parsed_file.difficulties =
              clear_list(content.split(":\n\n")[1].split('- '))
          elsif content.start_with?(@t[:pomodoros])
            parsed_file.pomodoros =
              content.split(":\n\n")[1].scan(/\d+/).first.to_i
          end
        end

        parsed_file
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def clear_list(list)
        return list unless list.is_a?(Array)

        list
          .map { |s| s.gsub('---', '') unless s.nil? }
          .filter { |s| (s != '') && (s != "\n\n") }
          .map(&:strip)
      end
    end
  end
end
