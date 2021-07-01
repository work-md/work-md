# frozen_string_literal: true

require 'fileutils'

RSpec.describe WorkMd::Commands::Today do
  let(:test_work_dir) { 'spec/test_work_dir' }

  before do
    allow(WorkMd::Config).to receive(:work_dir).and_return(test_work_dir)
  end

  after { FileUtils.rm_rf(test_work_dir) }

  context 'executing' do
    let(:today) { DateTime.now }
    let(:expected_md_file) { "#{WorkMd::Config.work_dir}/#{today.strftime('%Y/%m/%d')}.md" }
    let(:expected_md_file_dir) { "#{WorkMd::Config.work_dir}/#{today.strftime('%Y/%m')}" }

    it 'creates the md file in the work dir' do
      allow_any_instance_of(Kernel).to(
        receive(:system)
        .and_return(true)
      )

      described_class.execute([], { today: today })

      expect(
       ::File
        .exist?(expected_md_file)
      ).to be_truthy
    end

    it 'dont creates the md file when already exists' do
      allow_any_instance_of(Kernel).to(
        receive(:system)
        .and_return(true)
      )

      ::FileUtils.mkdir_p(expected_md_file_dir)
      ::File.open(expected_md_file, 'w+') { |f| f.puts("test") }

      described_class.execute([], { today: today })

      expect(
        ::File
        .exist?(expected_md_file)
      ).to be_truthy

      expect(File.read(expected_md_file)).to eq("test\n")
    end

    it 'opens the md file in the work dir' do
      expect_any_instance_of(Kernel).to(
        receive(:system)
          .with("#{WorkMd::Config.editor} #{today.strftime('%Y/%m/%d')}.md")
      )

      described_class.execute([], { today: today })
    end
  end
end
