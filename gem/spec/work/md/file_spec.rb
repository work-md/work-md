# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::File do
  context 'opening the md file in the work dir' do
    let(:file_name) { Work::Md::DateFile.create_if_not_exist(some_date) }
    let(:some_date) { DateTime.now }

    after do
      FileUtils.rm_rf(test_work_dir)
      ENV['EDITOR'] = nil
    end

    context 'when oppening many files' do
      before do
        allow(::TTY::Editor).to(
          receive(:open)
          .with(file_name, file_name)
          .and_return(true)
        )

        Work::Md::DateFile.create_if_not_exist(some_date)
      end

      it do
        expect(::TTY::Editor).to(
          receive(:open)
          .with(file_name, file_name)
        )
        described_class.open_in_editor([file_name, file_name])
      end
    end

    context 'when open parsed' do
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

        allow(DateTime).to receive(:now).and_return(today)
      end

      after { FileUtils.rm_rf(test_work_dir) }
      it do
        allow(::TTY::Editor).to(
          receive(:open)
          .and_return(true)
        )
        expect(::TTY::Editor).to(
          receive(:open)
          .and_return(true)
        )

        parser = Work::Md::Parser::Engine.new

        parser.add_file(file_1_path)

        described_class.create_and_open_parsed(parser)

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
      end
    end

    context 'when editor set' do
      let(:editor) { "vim" }

      before do
        allow(Work::Md::Config).to(receive(:editor).and_return(editor))
        allow(::TTY::Editor).to(
          receive(:open)
          .with(file_name, file_name)
          .and_return(true)
        )
        ENV['EDITOR'] = nil
      end

      it do
        expect(Work::Md::Config).to(receive(:editor).and_return(editor))
        expect(::TTY::Editor).to(
          receive(:open)
          .with(file_name, file_name)
        )

        described_class.open_in_editor([file_name, file_name])
        expect(ENV['EDITOR']).to eq(editor)
      end
    end
  end
end
