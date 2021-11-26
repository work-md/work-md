# frozen_string_literal: true

require 'date'

module Work
  module Md
    module Parser
      class Error < StandardError; end

      # rubocop:disable Metrics/ClassLength
      class Engine
        IS_FROZEN_ERROR_MESSAGE = 'Work::Md::Parser::Engine is frozen'
        IS_NOT_FROZEN_ERROR_MESSAGE = 'Work::Md::Parser::Engine is not frozen'

        class ParsedFile
          attr_accessor :tasks,
                        :meetings,
                        :interruptions,
                        :difficulties,
                        :observations,
                        :date,
                        :pomodoros
        end

        def initialize
          @t = Work::Md::Config.translations
          @parsed_files = []
          @frozen = false
        end

        def add_file(file)
          raise IS_FROZEN_ERROR_MESSAGE if @frozen

          begin
            file_content = ::File.read(file).squeeze(' ').strip
          rescue Errno::ENOENT
            return
          end

          return unless file_content.start_with?('# ')

          @parsed_files.push(parse_file_content(file_content))
        end

        def done_tasks
          raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

          @done_tasks ||=
            tasks.select { |t| t.start_with?('x]') || t.start_with?('X]') }
        end

        def tasks
          raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

          @tasks ||= @parsed_files.map(&:tasks).flatten
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

        def observations
          raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

          @observations ||= @parsed_files.map(&:observations).flatten
        end

        def average_pomodoros
          if @parsed_files.size.positive? && pomodoros_sum.positive?
            return (pomodoros_sum.to_f / @parsed_files.size).round(1)
          end

          0
        end

        def pomodoros_sum
          raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

          @pomodoros_sum ||=
            @parsed_files.reduce(0) { |sum, f| sum + f.pomodoros || 0 }
        end

        def pomodoros_bars(_file = nil)
          raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

          @pomodoros_bars ||=
            @parsed_files.map do |f|
              "(#{f.date}) #{(1..f.pomodoros).map { '⬛' }.join}"
            end
        end

        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/PerceivedComplexity
        def days_bars
          raise IS_NOT_FROZEN_ERROR_MESSAGE unless @frozen

          return @days_bars if @days_bars

          @days_bars ||=
            @parsed_files.map do |f|
              pom = (1..f.pomodoros).map { '⬛' }.join if f.pomodoros
              mee = f.meetings.map { '📅' }.join if f.meetings
              int = f.interruptions.map { '⚠️' }.join if f.interruptions
              dif = f.difficulties.map { '😓' }.join if f.difficulties
              obs = f.observations.map { '📝' }.join if f.observations
              tas = f.tasks.map { '✔️' }.join if f.tasks

              "(#{f.date}) #{pom}#{mee}#{int}#{dif}#{obs}#{tas}"
            end
        end
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/PerceivedComplexity

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
          if content.start_with?('# ')
            parsed_file.date =
              content.split(' - ')[0].gsub('# ', '').gsub("\n\n", '')
          elsif content.start_with?(@t[:tasks])
            parsed_file.tasks = parse_check_list(content, start_with: @t[:tasks])
          elsif content.start_with?(@t[:meetings])
            parsed_file.meetings = parse_check_list(content, start_with: @t[:meetings])
          elsif content.start_with?(@t[:interruptions])
            parsed_file.interruptions =
              parse_list(content, start_with: @t[:interruptions]).map do |interruption|
                "(#{parsed_file.date}) #{interruption}"
              end
          elsif content.start_with?(@t[:difficulties])
            parsed_file.difficulties =
              parse_list(
                content, start_with: @t[:difficulties]
              ).map do |difficulty|
                "(#{parsed_file.date}) #{difficulty}"
              end
          elsif content.start_with?(@t[:observations])
            parsed_file.observations =
              parse_list(
                content, start_with: @t[:observations]
              ).map do |observations|
                "(#{parsed_file.date}) #{observations}"
              end
          elsif content.start_with?(@t[:pomodoros])
            parsed_file.pomodoros =
              parse_pomodoro(content, start_with: @t[:pomodoros])
          end
        rescue StandardError
          # TODO: Write tests for this scenario
          file_name = Date.strptime(parsed_file.date, '%d/%m/%Y').strftime('%Y/%m/%d.md')
          message = ::TTY::Box.frame(
            "message: Cannot parse file '#{file_name}' maybe it's in an incorrect format.",
            '',
            'Usage example:',
            '',
            'work-md pl 7       # parse the last 7 days',
            **Work::Md::Cli.error_frame_style
          )

          raise Error, message
        end
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/PerceivedComplexity

        def parse_check_list(content, start_with: nil)
          clear_list(basic_parse(content, start_with: start_with).split('- ['))
        end

        def parse_list(content, start_with: nil)
          clear_list(basic_parse(content, start_with: start_with).split('- '))
        end

        def parse_pomodoro(content, start_with: nil)
          basic_parse(content, start_with: start_with).scan(/\d+/).first.to_i
        end

        def basic_parse(content, start_with: nil)
          unless start_with.nil?
            return content
                   .split("#{start_with}:")[1]
                   .squeeze(' ')
                   .sub("\n\n", "\n")
          end

          content.split(":\n\n")[1]
        end

        # rubocop:disable Metrics/CyclomaticComplexity
        def clear_list(list)
          return list unless list.is_a?(Array)

          list
            .map { |s| s.gsub('---', '') unless s.nil? }
            .select { |s| (s != "\n\n") && (s != "\n\n\n") }
            .map(&:strip)
            .reject { |s| (s == '') }
        end
        # rubocop:enable Metrics/CyclomaticComplexity
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
