# frozen_string_literal: true

RSpec.describe Rustic::Application do
  let(:cli) { described_class.new(argv) }

  describe "#run" do
    subject { cli.run }

    context "when the command is script" do
      let(:argv) { ["script", "backup.rb"] }
      let(:evaluator) { instance_double(Rustic::Script::Evaluator, evaluate: true) }
      let(:reader) { instance_double(Rustic::Script::Reader, read: config) }
      let(:config) { instance_double(Rustic::Script::Config) }

      before do
        allow(Rustic::Script::Reader).to receive(:new).with("backup.rb").and_return(reader)
        allow(Rustic::Script::Evaluator).to receive(:new).with(config).and_return(evaluator)
      end

      it "calls Rustic::Script::Evaluator#evaluate" do
        subject
        expect(evaluator).to have_received(:evaluate)
      end
    end

    context "when the command is not script" do
      let(:argv) { ["--help"] }
      let(:wrapper) { instance_double(Rustic::Wrapper, run: true) }

      before do
        allow(Rustic::Wrapper).to receive(:new).with(["restic", "--help"]).and_return(wrapper)
      end

      it "calls Rustic::Wrapper#run" do
        subject
        expect(wrapper).to have_received(:run)
      end
    end
  end
end
