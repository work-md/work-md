# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::File do
  context 'open or creating a file' do
    let(:some_date) { DateTime.now }

    after do
      FileUtils.rm_rf(test_work_dir)
      ENV['EDITOR'] = nil
    end

    let(:expected_md_file) { "#{Work::Md::Config.work_dir}/#{some_date.strftime('%Y/%m/%d')}.md" }
    let(:expected_md_file_dir) { "#{Work::Md::Config.work_dir}/#{some_date.strftime('%Y/%m')}" }
    let(:expected_md_file_2) { "#{Work::Md::Config.work_dir}/something/#{some_date.strftime('%Y/%m/%d')}.md" }
    let(:dir_2) { "#{Work::Md::Config.work_dir}/something" }

    it 'creates the md file in the work dir' do
      allow(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )

      described_class.open_or_create(some_date)

      expect(
       ::File
        .exist?(expected_md_file)
      ).to be_truthy

      t = Work::Md::Config.translations
      file_content = ::File.read(expected_md_file)

      expect(file_content).to match(Work::Md::Config.title)
      expect(file_content).to match(t[:tasks])
      expect(file_content).to match(t[:meetings])
      expect(file_content).to match(t[:interruptions])
      expect(file_content).to match(t[:difficulties])
      expect(file_content).to match(t[:observations])
      expect(file_content).to match(t[:pomodoros])
    end

    it 'creates the md file in any dir' do
      allow(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )

      described_class.open_or_create(some_date, dir: dir_2)

      expect(
        ::File
        .exist?(expected_md_file_2)
      ).to be_truthy

      t = Work::Md::Config.translations
      file_content = ::File.read(expected_md_file_2)

      expect(file_content).to match(Work::Md::Config.title)
    end

    it 'dont creates the md file when already exists' do
      allow(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )

      ::FileUtils.mkdir_p(expected_md_file_dir)
      ::File.open(expected_md_file, 'w+') { |f| f.puts("test") }

      described_class.open_or_create(some_date)

      expect(
        ::File
        .exist?(expected_md_file)
      ).to be_truthy

      expect(File.read(expected_md_file)).to eq("test\n")
    end

    context 'opening the md file in the work dir' do
      context 'when oppening many files' do
        let(:file_name) { described_class.create_if_not_exist(some_date) }

        before do
          allow(::TTY::Editor).to(
            receive(:open)
            .with(file_name, file_name)
            .and_return(true)
          )

          described_class.create_if_not_exist(some_date)
        end

        it do
          expect(::TTY::Editor).to(
            receive(:open)
            .with(file_name, file_name)
          )
          described_class.open_in_editor([file_name, file_name])
        end
      end

      context 'when editor not set' do
        before do
          allow(::TTY::Editor).to(
            receive(:open)
            .with("#{some_date.strftime('%Y/%m/%d')}.md")
            .and_return(true)
          )
        end

        it do
          expect(::TTY::Editor).to(
            receive(:open)
            .with("#{some_date.strftime('%Y/%m/%d')}.md")
          )

          described_class.open_or_create(some_date)
        end
      end

      context 'when editor set' do
        let(:editor) { "vim" }

        before do
          allow(Work::Md::Config).to(receive(:editor).and_return(editor))
          allow(::TTY::Editor).to(
            receive(:open)
            .with("#{some_date.strftime('%Y/%m/%d')}.md")
            .and_return(true)
          )
          ENV['EDITOR'] = nil
        end

        it do
          expect(Work::Md::Config).to(receive(:editor).and_return(editor))
          expect(::TTY::Editor).to(
            receive(:open)
            .with("#{some_date.strftime('%Y/%m/%d')}.md")
          )

          described_class.open_or_create(some_date)
          expect(ENV['EDITOR']).to eq(editor)
        end
      end
    end
  end
end
