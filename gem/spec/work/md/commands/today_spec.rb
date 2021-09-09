# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::Commands::Today do
  let(:today) { DateTime.now }

  before do
    allow(DateTime).to receive(:now).and_return(today)
  end

  after do
    FileUtils.rm_rf(test_work_dir)
    ENV['EDITOR'] = nil
  end

  context 'executing' do
    let(:expected_md_file) { "#{Work::Md::Config.work_dir}/#{today.strftime('%Y/%m/%d')}.md" }
    let(:expected_md_file_dir) { "#{Work::Md::Config.work_dir}/#{today.strftime('%Y/%m')}" }

    it 'creates the md file in the work dir' do
      allow(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )
      expect(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )

      described_class.execute([])

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
      expect(file_content).to match(t[:pomodoros])
    end

    it 'dont creates the md file when already exists' do
      allow(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )

      ::FileUtils.mkdir_p(expected_md_file_dir)
      ::File.open(expected_md_file, 'w+') { |f| f.puts("test") }

      described_class.execute([])

      expect(
        ::File
        .exist?(expected_md_file)
      ).to be_truthy

      expect(File.read(expected_md_file)).to eq("test\n")
    end

    context 'opening the md file in the work dir' do
      it 'when editor not set' do
        allow(::TTY::Editor).to(
          receive(:open)
          .with("#{today.strftime('%Y/%m/%d')}.md")
          .and_return(true)
        )

        described_class.execute([])
      end

      context 'when editor set' do
        let(:editor) { "vim" }

        before do
          allow(Work::Md::Config).to(receive(:editor).and_return(editor))
          allow(::TTY::Editor).to(
            receive(:open)
            .with("#{today.strftime('%Y/%m/%d')}.md")
            .and_return(true)
          )
          ENV['EDITOR'] = nil
        end

        it do
          expect(Work::Md::Config).to(receive(:editor).and_return(editor))
          expect(::TTY::Editor).to(
            receive(:open)
            .with("#{today.strftime('%Y/%m/%d')}.md")
          )

          described_class.execute([])
          expect(ENV['EDITOR']).to eq(editor)
        end
      end
    end
  end
end
