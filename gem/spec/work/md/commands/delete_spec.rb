# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::Commands::Delete do
  before do
    allow_any_instance_of(TTY::Prompt).to receive(:yes?).and_return(true)
  end

  context 'executing' do
    it 'given only day, it delete this day in current month and year' do
      allow(::File).to(receive(:delete).and_return(true))
      allow(::File).to(receive(:exist?).and_return(true))

      expected_file_to_open = Work::Md::Config.work_dir + "/#{Time.new.year}/#{Time.new.month}/30.md"

      expect(::File)
        .to(receive(:delete).with(expected_file_to_open))

      described_class.execute(["-d=30"])
    end

    it 'given two days, it delete this days in current month and year' do
      allow(::File).to(receive(:delete).and_return(true))
      allow(::File).to(receive(:exist?).and_return(true))

      expected_file_to_open1 = Work::Md::Config.work_dir + "/#{Time.new.year}/#{Time.new.month}/30.md"
      expected_file_to_open2 = Work::Md::Config.work_dir + "/#{Time.new.year}/#{Time.new.month}/25.md"

      expect(::File)
        .to(receive(:delete).with(expected_file_to_open1))
      expect(::File)
        .to(receive(:delete).with(expected_file_to_open2))

      described_class.execute(["-d=30,25"])
    end

    it 'given month, day and year, it delete this day in given month and year' do
      allow(::File).to(receive(:delete).and_return(true))
      allow(::File).to(receive(:exist?).and_return(true))

      expected_file_to_open = Work::Md::Config.work_dir + "/1999/02/30.md"

      expect(::File)
        .to(receive(:delete).with(expected_file_to_open))

      described_class.execute(["-d=30","-m=2","-y=1999"])
    end

    context 'error' do
      describe 'when file not exists' do
        it 'returns a message' do
          allow(::File).to(receive(:delete).and_return(true))
          allow(::File).to(receive(:exist?).and_return(false))

          expect(::File)
            .to_not(receive(:delete))

          expect { described_class.execute(["-d=30","-m=2","-y=1999"]) }
            .to output(/message: File\(s\) not found!/).to_stdout
        end
      end
    end
  end
end
