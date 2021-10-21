# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::Commands::Last do
  let(:last) { Date.today.prev_day.prev_day.prev_day }

  after do
    FileUtils.rm_rf(test_work_dir)
    ENV['EDITOR'] = nil
  end

  context 'executing' do
    let(:expected_md_file) { "#{Work::Md::Config.work_dir}/#{last.strftime('%Y/%m/%d')}.md" }
    let(:expected_md_file_dir) { "#{Work::Md::Config.work_dir}/#{last.strftime('%Y/%m')}" }

    it 'open the last md file when already exists' do
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

    it 'show message when no file is found in last 90 days' do
      allow(::TTY::Editor).to(
        receive(:open)
        .and_return(true)
      )

      expect(
        ::File
        .exist?(expected_md_file)
      ).to be_falsey

      expect { described_class.execute([]) }
        .to output(/No file found in last 90 days/).to_stdout
    end

    context 'opening the md file in the work dir' do
      before do
        ::FileUtils.mkdir_p(expected_md_file_dir)
        ::File.open(expected_md_file, 'w+') { |f| f.puts("test") }
      end

      it 'when editor not set' do
        allow(::TTY::Editor).to(
          receive(:open)
          .with("#{last.strftime('%Y/%m/%d')}.md")
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
            .with("#{last.strftime('%Y/%m/%d')}.md")
            .and_return(true)
          )
          ENV['EDITOR'] = nil
        end

        it do
          expect(Work::Md::Config).to(receive(:editor).and_return(editor))
          expect(::TTY::Editor).to(
            receive(:open)
            .with("#{last.strftime('%Y/%m/%d')}.md")
          )

          described_class.execute([])
          expect(ENV['EDITOR']).to eq(editor)
        end
      end
    end
  end
end
