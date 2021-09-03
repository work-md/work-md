# frozen_string_literal: true

require 'fileutils'

RSpec.describe WorkMd::Commands::Annotations do
  let(:annotations_file) { "annotations.md" }

  after do
    FileUtils.rm_rf(test_work_dir)
    ENV['EDITOR'] = nil
  end

  context 'executing' do
    let(:expected_md_file) { "#{WorkMd::Config.work_dir}/#{annotations_file}" }
    let(:expected_md_file_dir) { "#{WorkMd::Config.work_dir}" }

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

      expect(file_content).to match("# \n\n")
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
          .with("#{annotations_file}")
          .and_return(true)
        )

        described_class.execute([])
      end

      context 'when editor set' do
        let(:editor) { "vim" }

        before do
          allow(WorkMd::Config).to(receive(:editor).and_return(editor))
          allow(::TTY::Editor).to(
            receive(:open)
            .with("#{annotations_file}")
            .and_return(true)
          )
          ENV['EDITOR'] = nil
        end

        it do
          expect(WorkMd::Config).to(receive(:editor).and_return(editor))
          expect(::TTY::Editor).to(
            receive(:open)
            .with("#{annotations_file}")
          )

          described_class.execute([])
          expect(ENV['EDITOR']).to eq(editor)
        end
      end
    end
  end
end
