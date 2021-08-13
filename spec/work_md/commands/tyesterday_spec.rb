# frozen_string_literal: true

require 'fileutils'

RSpec.describe WorkMd::Commands::Tyesterday do
  let(:today) { DateTime.now }
  let(:yesterday) { Date.today.prev_day }

  before do
    allow(Date).to receive(:today).and_return(double(prev_day: yesterday))
    allow(DateTime).to receive(:now).and_return(today)
  end

  context 'executing' do
    it 'opens or create today and yesterday files' do
      allow(WorkMd::File).to(receive(:open_or_create).with(today).and_return(true))
      allow(WorkMd::File).to(receive(:open_or_create).with(yesterday).and_return(true))
    end
  end
end
