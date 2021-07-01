# frozen_string_literal: true

RSpec.describe WorkMd::Commands::Today do
  before do
    allow(WorkMd::Config).to receive(:work_dir).and_return('spec/test_work_dir')
  end

  context 'executing' do
    let(:today) { DateTime.now }

    it 'opens the md file' do
      expect_any_instance_of(Kernel).to(
        receive(:system)
          .with("#{WorkMd::Config.editor} #{today.strftime('%Y/%m/%d')}.md")
      )

      described_class.execute([], {today: today})
    end
  end
end
