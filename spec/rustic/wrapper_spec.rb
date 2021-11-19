# frozen_string_literal: true

RSpec.describe Rustic::Wrapper do
  let(:wrapper) { described_class.new(argv, env_variables) }
  let(:argv) {  %w[some command] }
  let(:env_variables) { { "some" => "variable" } }

  describe "#run" do
    subject { wrapper.run }

    context "when command succeeds" do
      before do
        status = instance_double(Process::Status, exitstatus: 0)
        allow(Async::Process).to receive(:spawn).with(env_variables, *argv).and_return(status)
      end

      it "does not raise exceptions" do
        expect { subject }.not_to raise_error
      end
    end

    context "when command fails" do
      before do
        status = instance_double(Process::Status, exitstatus: 1)
        allow(Async::Process).to receive(:spawn).with(env_variables, *argv).and_return(status)
      end

      it "raises an exception" do
        expect { subject }.to raise_error(described_class::ExitStatusError, "Exit status is not 0: 1")
      end
    end

    context "when command not found" do
      before do
        allow(Async::Process).to receive(:spawn).with(env_variables, *argv).and_raise(Errno::ENOENT)
      end

      it "raises an exception" do
        expect { subject }.to raise_error(described_class::ExecutionError)
      end
    end
  end
end
