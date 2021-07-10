# frozen_string_literal: true

RSpec.describe WorkMd::Cli do
  describe "executing today command" do
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
  end

  describe "using info" do
    it "outputs info message" do
      message = "some message"

      expect { WorkMd::Cli.info(message) }
        .to output(/Track your work activities, write annotations/).to_stdout
      expect { WorkMd::Cli.info(message) }
        .to output(/#{message}/).to_stdout
    end
  end

  describe "using alias" do
    it do
      WorkMd::Cli::ALIAS_COMMANDS.each do |alias_command|
        argv = [alias_command.first]

        expect(Object
          .const_get(
            "WorkMd::Commands::#{alias_command.last.capitalize}")
              )
                .to(receive(:execute).with([]))

        WorkMd::Cli.execute(argv)
      end
    end
  end

  context "command is empty" do
    it "executes the default command" do
      argv = []

      expect(WorkMd::Cli::DEFAULT_COMMAND).to(receive(:execute).with([]))

      WorkMd::Cli.execute(argv)
    end
  end

  context "command dont exist" do
    it "outputs error message" do
      argv = ["not_existent"]

      expect { WorkMd::Cli.execute(argv) }
        .to output(/Command 'not_existent' not found!/).to_stdout
    end
  end
end
