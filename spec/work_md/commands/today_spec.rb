# frozen_string_literal: true

require 'fileutils'

RSpec.describe WorkMd::Commands::Today do
  let(:today) { DateTime.now }

  before do
    allow(DateTime).to receive(:now).and_return(today)
  end

  after { FileUtils.rm_rf(test_work_dir) }

  context 'executing' do
    let(:expected_md_file) { "#{WorkMd::Config.work_dir}/#{today.strftime('%Y/%m/%d')}.md" }
    let(:expected_md_file_dir) { "#{WorkMd::Config.work_dir}/#{today.strftime('%Y/%m')}" }

    it 'creates the md file in the work dir' do
      allow(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )

      described_class.execute([])

      expect(
       ::File
        .exist?(expected_md_file)
      ).to be_truthy

      t = WorkMd::Config.translations
      file_content = ::File.read(expected_md_file)

      expect(file_content).to match(WorkMd::Config.title)
      expect(file_content).to match(t[:tasks])
      expect(file_content).to match(t[:meetings])
      expect(file_content).to match(t[:annotations])
      expect(file_content).to match(t[:meeting_annotations])
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

      it 'when editor set' do
        editor = "vim"

        allow(WorkMd::Config).to(receive(:editor).and_return(editor))
        allow(::TTY::Editor).to(
          receive(:open)
          .with("#{today.strftime('%Y/%m/%d')}.md", { command: editor })
          .and_return(true)
        )

        described_class.execute([])
      end
    end
  end
end
