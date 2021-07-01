# frozen_string_literal: true

RSpec.describe WorkMd::Cli do
  describe "executing the given command" do
    context "when options not given" do
      it "execute the given command" do
        argv = ["today"]

        expect(WorkMd::Commands::Today).to receive(:execute).with([])

        WorkMd::Cli.execute(argv)
      end
    end

    context "when options given" do
      it "put the options in the command" do
        argv = %w[today opt test]

        expect(WorkMd::Commands::Today)
          .to receive(:execute).with(%w[opt test])

        WorkMd::Cli.execute(argv)
      end
    end

    context "command is empty" do
      it "outputs error message" do
        argv = []

        expect { WorkMd::Cli.execute(argv) }
          .to output(/Command missing!/).to_stdout
      end
    end

    context "command dont exist" do
      it "outputs error message" do
        argv = ["not_existent"]

        expect { WorkMd::Cli.execute(argv) }
          .to output(/Command not_existent not found!/).to_stdout
      end
    end
  end
end
