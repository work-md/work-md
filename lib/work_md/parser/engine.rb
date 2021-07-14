# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
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

      def average_pomodoros
        if @parsed_files.size.positive? && pomodoros.positive?
          return (pomodoros / @parsed_files.size)
        end

        0
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

      def parse_file_content(file_content)
        parsed_file = ParsedFile.new

        file_content
          .split('### ')
          .each { |content| parse_content(parsed_file, content) }

        parsed_file
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def parse_content(parsed_file, content)
        if content.start_with?(@t[:tasks])
          parsed_file.tasks = parse_task_list(content)
        elsif content.start_with?(@t[:meetings])
          parsed_file.meetings = parse_list(content)
        elsif content.start_with?(@t[:meeting_annotations])
          parsed_file.meeting_annotations = basic_parse(content)
        elsif content.start_with?(@t[:annotations])
          parsed_file.annotations = basic_parse(content)
        elsif content.start_with?(@t[:interruptions])
          parsed_file.interruptions = parse_list(content)
        elsif content.start_with?(@t[:difficulties])
          parsed_file.difficulties = parse_list(content)
        elsif content.start_with?(@t[:pomodoros])
          parsed_file.pomodoros = parse_pomodoro(content)
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def parse_task_list(content)
        clear_list(basic_parse(content).split('- ['))
      end

      def parse_list(content)
        clear_list(basic_parse(content).split('- '))
      end

      def parse_pomodoro(content)
        basic_parse(content).scan(/\d+/).first.to_i
      end

      def basic_parse(content)
        content.split(":\n\n")[1]
      end

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
# rubocop:enable Metrics/ClassLength
