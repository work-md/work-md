# frozen_string_literal: true

require 'fileutils'

RSpec.describe Work::Md::Commands::Open do
  context 'executing' do
    it 'given only day, it open this day in current month and year' do
      allow(Work::Md::File).to(receive(:open_in_editor).and_return(true))
      allow(::File).to(receive(:exist?).and_return(true))

      expected_file_to_open = Work::Md::Config.work_dir + "/#{Time.new.year}/#{Time.new.month}/30.md"

      expect(Work::Md::File)
        .to(receive(:open_in_editor).with([expected_file_to_open]))

      described_class.execute(["-d=30"])
    end

    it 'given two days, it open this days in current month and year' do
      allow(Work::Md::File).to(receive(:open_in_editor).and_return(true))
      allow(::File).to(receive(:exist?).and_return(true))

      expected_file_to_open1 = Work::Md::Config.work_dir + "/#{Time.new.year}/#{Time.new.month}/30.md"
      expected_file_to_open2 = Work::Md::Config.work_dir + "/#{Time.new.year}/#{Time.new.month}/25.md"

      expect(Work::Md::File)
        .to(receive(:open_in_editor).with([expected_file_to_open1, expected_file_to_open2]))

      described_class.execute(["-d=30,25"])
    end

    it 'given month, day and year, it open this day in given month and year' do
      allow(Work::Md::File).to(receive(:open_in_editor).and_return(true))
      allow(::File).to(receive(:exist?).and_return(true))

      expected_file_to_open = Work::Md::Config.work_dir + "/1999/02/30.md"

      expect(Work::Md::File)
        .to(receive(:open_in_editor).with([expected_file_to_open]))

      described_class.execute(["-d=30","-m=2","-y=1999"])
    end

    context 'error' do
      describe 'when file not exists' do
        it 'returns a message' do
          allow(Work::Md::File).to(receive(:open_in_editor).and_return(true))
          allow(::File).to(receive(:exist?).and_return(false))

          expect(Work::Md::File)
            .to_not(receive(:open_in_editor))

          expect { described_class.execute(["-d=30","-m=2","-y=1999"]) }
            .to output(/message: File\(s\) not found!/).to_stdout
        end
      end
    end
  end
end
