# frozen_string_literal: true

RSpec.describe WorkMd::Parser::Engine do
  describe "parsing work_md files" do
    let(:test_work_dir) { 'spec/test_work_dir' }
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
      allow(WorkMd::Config).to receive(:work_dir).and_return(test_work_dir)
      allow(WorkMd::Config).to(
        receive(:translations).and_return(WorkMd::Config::TRANSLATIONS['en'])
      )
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
