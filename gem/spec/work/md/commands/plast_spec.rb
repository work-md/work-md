# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::Commands::Plast do
  let(:today) { DateTime.parse "20210729" }
  let(:yesterday) { Date.today.prev_day }

  before do
    allow(DateTime).to receive(:now).and_return(today)
    allow(Date).to receive(:today).and_return(double(prev_day: yesterday))
  end

  context 'executing' do
    it 'it parses the last files' do
      double_parser = double("parser")
      allow(double_parser).to(receive(:add_file).and_return(true))
      allow(Work::Md::Parser::Engine).to(receive(:new).and_return(double_parser))

      allow(::File).to(receive(:exist?).and_return(true))
      allow(Work::Md::File).to(receive(:create_and_open_parsed).and_return(true))

      expect(double_parser).to receive(:add_file).exactly(2).times
      expect(Work::Md::File).to(receive(:create_and_open_parsed).with(double_parser))

      described_class.execute(["2"])
    end

    it 'it show message if not numeric argument is given' do
      expect(::TTY::Editor).to_not(
        receive(:open)
      )
      expect { described_class.execute(["-d bla"]) }
        .to output(/you give: ["-d bla"]/).to_stdout
    end
  end
end
