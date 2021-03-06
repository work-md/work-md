# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::Commands::Parse do
  let(:today) { DateTime.now }
  let(:file_1_path) { "#{test_work_dir}/#{today.strftime('%Y/%m/%d')}.md" }
  let(:file_2_path) { "#{test_work_dir}/#{today.strftime('%Y/%m/%d')}2.md" }
  let(:parsed_file_path) { Work::Md::Config.work_dir + '/parsed.md' }

  before do
    ::FileUtils
      .mkdir_p("#{test_work_dir}/#{today.strftime('%Y/%m')}")

    FileUtils
      .cp(
        'spec/fixtures/work_md_file.md',
        file_1_path
      )

    FileUtils
      .cp(
        'spec/fixtures/work_md_file2.md',
        file_2_path
      )

    allow(DateTime).to receive(:now).and_return(today)
  end

  after { FileUtils.rm_rf(test_work_dir) }

  context 'executing' do
    it 'creates the parsed.md file in the work dir' do
      allow(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )
      expect(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )

      described_class.execute(["-d=#{today.strftime('%d')}"])

      expect(
       ::File
        .exist?(parsed_file_path)
      ).to be_truthy

      t = Work::Md::Config.translations
      file_content = ::File.read(parsed_file_path)

      expect(file_content).to match(t[:tasks])
      expect(file_content).to match(t[:meetings])
      expect(file_content).to match(t[:interruptions])
      expect(file_content).to match(t[:difficulties])
      expect(file_content).to match(t[:observations])
      expect(file_content).to match(t[:pomodoros])
      expect(file_content).to match(t[:days_bars])
      expect(file_content).to match(t[:total])
      expect(file_content).to match(/\b2\b/)
      expect(file_content).to match(/\b1\b/)
    end

    context 'using range arguments' do
      it 'creates the parsed.md file in the work dir' do
        allow(::TTY::Editor).to(
          receive(:open)
          .and_return(true)
        )

        described_class.execute(["-d=1..#{today.strftime('%d')}"])

        expect(
          ::File
          .exist?(parsed_file_path)
        ).to be_truthy

        t = Work::Md::Config.translations
        file_content = ::File.read(parsed_file_path)

        expect(file_content).to match(t[:tasks])
        expect(file_content).to match(t[:meetings])
        expect(file_content).to match(t[:interruptions])
        expect(file_content).to match(t[:difficulties])
        expect(file_content).to match(t[:observations])
        expect(file_content).to match(t[:pomodoros])
        expect(file_content).to match(t[:days_bars])
        expect(file_content).to match(t[:total])
        expect(file_content).to match(/\b2\b/)
        expect(file_content).to match(/\b1\b/)
      end
    end

    context 'composing arguments' do
      it 'creates the parsed.md file in the work dir' do
        allow(::TTY::Editor).to(
          receive(:open)
          .and_return(true)
        )

        described_class.execute(["-d=#{today.strftime('%d')}", 'and', "-d=#{today.strftime('%d')}"])

        expect(
          ::File
          .exist?(parsed_file_path)
        ).to be_truthy

        t = Work::Md::Config.translations
        file_content = ::File.read(parsed_file_path)

        expect(file_content).to match(t[:tasks])
        expect(file_content).to match(t[:meetings])
        expect(file_content).to match(t[:interruptions])
        expect(file_content).to match(t[:difficulties])
        expect(file_content).to match(t[:observations])
        expect(file_content).to match(t[:pomodoros])
        expect(file_content).to match(t[:days_bars])
        expect(file_content).to match(t[:total])
        expect(file_content).to match(/\b4\b/)
        expect(file_content).to match(/\b2\b/)
      end
    end

    context 'opening the md file in the work dir' do
      it 'when editor not set' do
        allow(::TTY::Editor).to(
          receive(:open)
          .with(parsed_file_path)
          .and_return(true)
        )

        described_class.execute(["-d=#{today.strftime('%d')}"])
      end

      it 'when editor set' do
        editor = "vim"

        allow(Work::Md::Config).to(receive(:editor).and_return(editor))
        allow(::TTY::Editor).to(
          receive(:open)
          .with(parsed_file_path)
          .and_return(true)
        )

        described_class.execute(["-d=#{today.strftime('%d')}"])
      end
    end

    context 'when error happened' do
      it 'prints usage examples' do
        expect(::TTY::Editor).to_not(
          receive(:open)
          .with(
            parsed_file_path
          )
        )

        expect { described_class.execute(["-d bla"]) }
          .to output(/Usage examples:/).to_stdout

      end
    end
  end
end
