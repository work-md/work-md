# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::Commands::Tlast do
  let(:today) { DateTime.parse "20210729" }
  let(:yesterday) { Date.today.prev_day }

  before do
    allow(DateTime).to receive(:now).and_return(today)
    allow(Date).to receive(:today).and_return(double(prev_day: yesterday))
  end

  context 'executing' do
    it 'opens or create today file and open last file' do
      allow(Work::Md::DateFile).to(receive(:create_if_not_exist).and_return("today_file_name"))
      allow(Work::Md::File).to(receive(:open_in_editor).and_return(true))

      expect(Work::Md::DateFile)
        .to(receive(:create_if_not_exist).with(today))
      expect(Work::Md::File)
        .to(receive(:open_in_editor).with(["today_file_name", "2021/07/23.md"]))

      described_class.execute([])
    end
  end
end
