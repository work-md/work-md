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
        expect(parser.annotations).to eq([])
        expect(parser.meeting_annotations).to eq([])
        expect(parser.interruptions).to eq([])
        expect(parser.difficulties).to eq([])
        expect(parser.pomodoros).to eq(0)
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
        expect(parser.meetings).to eq(["Meeting", "Meeting 2", "Meeting", "Meeting 2"])
        expect(parser.annotations).to eq(["Some annotation\n\n###", "Some annotation\n\n###"])
        expect(parser.meeting_annotations).to eq(["Some meeting annotation\n\n", "Some meeting annotation\n\n"])
        expect(parser.interruptions).to eq(["Some interruption", "Some interruption"])
        expect(parser.difficulties).to eq(["Some difficulty", "Some difficulty"])
        expect(parser.pomodoros).to eq(14)
      end
    end
  end
end