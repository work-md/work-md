# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::Commands::Config do
  after do
    FileUtils.rm_rf(test_work_dir)
  end

  context 'executing' do
    let(:file_name) { "config.yml" }
    let(:expected_config_file_dir) { ::Work::Md::Config::DEFAULT_WORK_DIR }
    let(:expected_config_file) { "#{expected_config_file_dir}/#{file_name}" }

    it 'creates and open the config file in the default work dir' do
      allow(Work::Md::DateFile).to(receive(:open_in_editor).and_return(true))
      expect(Work::Md::File).to(receive(:open_in_editor))

      described_class.execute([])

      expect(
       ::File.exist?(expected_config_file)
      ).to be_truthy

      t = Work::Md::Config.translations
      file_content = ::File.read(expected_config_file)

      expect(file_content).to match("# Example configuration:")
      expect(file_content).to match("# title: Your Name")
      expect(file_content).to match("# editor: vim")
      expect(file_content).to match("# lang: en")
      expect(file_content).to match("title: # Title your work-md files")
      expect(file_content).to match("editor: # Your default editor")
      expect(file_content).to match("lang: # Only 'pt', 'en' and 'es' avaiable")
    end

    it 'dont creates the config file in the default work dir when already exists' do
      allow(Work::Md::File).to(receive(:open_in_editor).and_return(true))

      ::FileUtils.mkdir_p(expected_config_file_dir)
      ::File.open(expected_config_file, 'w+') { |f| f.puts("test") }

      described_class.execute([])

      expect(
        ::File
        .exist?(expected_config_file)
      ).to be_truthy

      expect(File.read(expected_config_file)).to eq("test\n")
    end

    context 'opening the config file in the work dir' do
      before do
        allow(Work::Md::File).to(receive(:open_in_editor).and_return(true))
      end

      it do
        expect(Work::Md::File).to(
          receive(:open_in_editor)
          .with(
            [file_name],
            dir: ::Work::Md::Config::DEFAULT_WORK_DIR
          )
        )

        described_class.execute([])
      end
    end
  end
end
