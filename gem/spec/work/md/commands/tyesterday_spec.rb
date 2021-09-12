# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::Commands::Tyesterday do
  let(:today) { DateTime.now }
  let(:yesterday) { Date.today.prev_day }

  before do
    allow(DateTime).to receive(:now).and_return(today)
    allow(Date).to receive(:today).and_return(double(prev_day: yesterday))
  end

  context 'executing' do
    it 'opens or create today and yesterday files' do
      allow(Work::Md::DateFile).to(receive(:create_if_not_exist).and_return(true))
      allow(Work::Md::DateFile).to(receive(:create_if_not_exist).and_return(true))
      allow(Work::Md::File).to(receive(:open_in_editor).and_return(true))
      allow(Work::Md::File).to(receive(:open_in_editor).and_return(true))

      expect(Work::Md::DateFile)
        .to(receive(:create_if_not_exist).with(today))
      expect(Work::Md::DateFile)
        .to(receive(:create_if_not_exist).with(yesterday))
      expect(Work::Md::File)
        .to(receive(:open_in_editor))

      described_class.execute([])
    end
  end
end
