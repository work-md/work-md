# frozen_string_literal: true

RSpec.describe Work::Md::Cli do
  describe "executing today command" do
    context "when options not given" do
      it "execute the given command" do
        argv = ["today"]

        expect(Work::Md::Commands::Today).to receive(:execute).with([])

        Work::Md::Cli.execute(argv)
      end
    end

    context "when options given" do
      it "put the options in the command" do
        argv = %w[today opt test]

        expect(Work::Md::Commands::Today)
          .to receive(:execute).with(%w[opt test])

        Work::Md::Cli.execute(argv)
      end
    end
  end

  describe "using help" do
    it "outputs help message" do
      message = "some message"

      expect { Work::Md::Cli.help(message) }
        .to output(/Track your work activities, write annotations/).to_stdout
      expect { Work::Md::Cli.help(message) }
        .to output(/#{message}/).to_stdout
    end
  end

  describe "using alias" do
    it do
      Work::Md::Cli::ALIAS_COMMANDS.each do |alias_command|
        argv = [alias_command.first]

        expect(Object
          .const_get(
            "Work::Md::Commands::#{alias_command.last.capitalize}")
              )
                .to(receive(:execute).with([]))

        Work::Md::Cli.execute(argv)
      end
    end
  end

  context "command is empty" do
    it "executes the default command" do
      argv = []

      expect(Work::Md::Cli).to(receive(:help).with('Welcome! =)'))

      Work::Md::Cli.execute(argv)
    end
  end

  context "command dont exist" do
    it "outputs error message" do
      argv = ["not_existent"]

      expect { Work::Md::Cli.execute(argv) }
        .to output(/Command 'not_existent' not found!/).to_stdout
    end
  end
end
