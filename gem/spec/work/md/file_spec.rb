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
