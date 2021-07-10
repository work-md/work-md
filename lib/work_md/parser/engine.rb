# frozen_string_literal: true

module WorkMd
  module Parser
    class Engine
      FROZEN_ERROR_MESSAGE = "#{self.class.name} is frozen"

      class ParsedFile
        attr_accessor :tasks,
                      :annotations,
                      :meeting_annotations,
                      :meetings,
                      :interruptions,
                      :difficulties,
                      :pomodoros,
                      :point
      end

      def initialize
        @t = WorkMd::Config.translations
        @parsed_files = []
        @frozen = false
      end

      def add_file(file)
        raise FROZEN_ERROR_MESSAGE if @frozen

        file_content = File.read(file)

        if file_content.start_with?('# ')
          @parsed_files.push(parse_file_content(file_content))
        end
      rescue Errno::ENOENT
      end

      def done_tasks
        raise FROZEN_ERROR_MESSAGE if @frozen

        @done_tasks ||=
          tasks.filter { |t| t.start_with?('x]') || t.start_with?('X]') }
      end

      def tasks
        raise FROZEN_ERROR_MESSAGE if @frozen

        @tasks ||= @parsed_files.map(&:tasks).flatten
      end

      def annotations
        raise FROZEN_ERROR_MESSAGE if @frozen

        @annotations ||= @parsed_files.map(&:annotations).flatten
      end

      def meeting_annotations
        raise FROZEN_ERROR_MESSAGE if @frozen

        @meeting_annotations ||= @parsed_files.map(&:meeting_annotations).flatten
      end

      def meetings
        raise FROZEN_ERROR_MESSAGE if @frozen

        @meetings ||= @parsed_files.map(&:meetings).flatten
      end

      def interruptions
        raise FROZEN_ERROR_MESSAGE if @frozen

        @interruptions ||= @parsed_files.map(&:interruptions).flatten
      end

      def difficulties
        raise FROZEN_ERROR_MESSAGE if @frozen

        @difficulties ||= @parsed_files.map(&:difficulties).flatten
      end

      def pomodoros
        raise FROZEN_ERROR_MESSAGE if @frozen

        @pomodoros ||=
          @parsed_files.reduce(0) { |sum, f| sum + f.pomodoros || 0 }
      end

      def point
        raise FROZEN_ERROR_MESSAGE if @frozen

        @point ||= @parsed_files.map(&:point).flatten
      end

      def freeze
        @frozen = true
      end

      private

      def parse_file_content(file_content)
        parsed_file = ParsedFile.new

        contents_by_title = file_content.split('### ')

        contents_by_title.each do |c|
          if c.start_with?(@t[:tasks])
            parsed_file.tasks = clear_list(c.split(":\n\n")[1].split('- ['))
          elsif c.start_with?(@t[:meetings])
            parsed_file.meetings = clear_list(c.split(":\n\n")[1].split('- '))
          elsif c.start_with?(@t[:annotations])
            parsed_file.annotations = clear_list(c.split(":\n\n")[1])
          elsif c.start_with?(@t[:meeting_annotations])
            parsed_file.meeting_annotations = clear_list(c.split(":\n\n")[1].split('- '))
          elsif c.start_with?(@t[:interruptions])
            parsed_file.interruptions = clear_list(c.split(":\n\n")[1].split('- '))
          elsif c.start_with?(@t[:difficulties])
            parsed_file.difficulties = clear_list(c.split(":\n\n")[1].split('- '))
          elsif c.start_with?(@t[:pomodoros])
            parsed_file.pomodoros = c.split(":\n\n")[1].scan(/\d+/).first.to_i
          elsif c.start_with?(@t[:point])
            parsed_file.point = clear_list(c.split(":\n\n")[1].split('- '))
          end
        end

        parsed_file
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
