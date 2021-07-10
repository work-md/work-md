# frozen_string_literal: true

RSpec.describe WorkMd::Parser::Engine do
  describe "parsing a work_md file" do
    let(:test_work_dir) { 'spec/test_work_dir' }
    let(:today) { DateTime.now }
    let(:test_file_path) { "#{test_work_dir}/#{today.strftime('%Y/%m/%d')}.md" }

    before do
      ::FileUtils
        .mkdir_p("#{test_work_dir}/#{today.strftime('%Y/%m')}")

      FileUtils
        .cp(
          'spec/fixtures/work_md_file.md',
          test_file_path
        )

      allow(DateTime).to receive(:now).and_return(today)
      allow(WorkMd::Config).to receive(:work_dir).and_return(test_work_dir)
    end

    after { FileUtils.rm_rf(test_work_dir) }

    it do
      parser = WorkMd::Parser::Engine.new

      parser.add_file(test_file_path)
      parser.freeze

      expect(parser.tasks).to eq(["] Do something", "x] Do something 2"])
      expect(parser.meetings).to eq(["Meeting", "Meeting 2"])
      expect(parser.annotations).to eq(["Some annotation\n\n###"])
      expect(parser.meeting_annotations).to eq(["Some meeting annotation"])
      expect(parser.interruptions).to eq(["Some interruption"])
      expect(parser.difficulties).to eq(["Some difficultie"])
      expect(parser.pomodoros).to eq(4)
    end
  end
end
