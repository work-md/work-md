# frozen_string_literal: true

RSpec.describe WorkMd::Parser::Engine do
  describe "parsing work_md files" do
    context "when not find a work_md file" do
      it do
        parser = WorkMd::Parser::Engine.new

        parser.add_file("not existent")
        parser.freeze

        expect(parser.tasks).to eq([])
        expect(parser.meetings).to eq([])
        expect(parser.interruptions).to eq([])
        expect(parser.difficulties).to eq([])
        expect(parser.observations).to eq([])
        expect(parser.pomodoros_sum).to eq(0)
        expect(parser.average_pomodoros).to eq(0)
        expect(parser.pomodoros_bars).to eq([])
        expect(parser.days_bars).to eq([])
      end
    end

    context "with two work_md files" do
      let(:today) { DateTime.now }
      let(:file_1_path) { "#{test_work_dir}/#{today.strftime('%Y/%m/%d')}.md" }
      let(:file_2_path) { "#{test_work_dir}/#{today.strftime('%Y/%m/%d')}2.md" }

      before do
        ::FileUtils
          .mkdir_p("#{test_work_dir}/#{today.strftime('%Y/%m')}")

        FileUtils
          .cp(
            'spec/fixtures/work_md_file.md',
            file_1_path
          )

        FileUtils
          .cp(
            'spec/fixtures/work_md_file2.md',
            file_2_path
          )

        allow(DateTime).to receive(:now).and_return(today)
      end

      after { FileUtils.rm_rf(test_work_dir) }

      it do
        parser = WorkMd::Parser::Engine.new

        parser.add_file(file_1_path)
        parser.add_file(file_2_path)
        parser.freeze

        expect(parser.tasks).to eq(["] Do something", "x] Do something 2", "] Do something", "x] Do something 2"])
        expect(parser.meetings).to eq(["] Meeting", "x] Meeting 2", "] Meeting", "x] Meeting 2"])
        expect(parser.interruptions).to eq(["(00/00/0000) Some interruption", "(00/00/0000) Some interruption"])
        expect(parser.difficulties).to eq(["(00/00/0000) Some difficulty", "(00/00/0000) Some difficulty"])
        expect(parser.observations).to eq(["(00/00/0000) Some observation", "(00/00/0000) Some observation"])
        expect(parser.pomodoros_sum).to eq(13)
        expect(parser.average_pomodoros).to eq(6.5)
        expect(parser.pomodoros_bars).to eq(["(00/00/0000) ⬛⬛⬛", "(00/00/0000) ⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛"])
        expect(parser.days_bars).to eq(["(00/00/0000) ⬛⬛⬛📅📅⚠️😓📝✔️✔️", "(00/00/0000) ⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛📅📅⚠️😓📝✔️✔️"])
      end
    end
  end
end
