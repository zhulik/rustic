# frozen_string_literal: true

RSpec.describe Rustic::Evaluator do
  let(:evaluator) { described_class.new(config) }
  let(:config) { instance_double(Rustic::Config, repository: "./repository", password: "password", restic_path: "restic", on_error: on_error, before: before_hook, after: after_hook, backup_config: backup_config) }
  let(:wrapper) { instance_double(Rustic::Wrapper, run: true) }
  let(:on_error) { instance_double(Proc, call: true) }
  let(:before_hook) { instance_double(Proc, call: true) }
  let(:after_hook) { instance_double(Proc, call: true) }
  let(:backup_config) { nil }

  describe "#evaluate" do
    subject { evaluator.evaluate }

    context "when before hook raises an exception" do
      before do
        allow(before_hook).to receive(:call).and_raise(RuntimeError)
      end

      include_examples "raises an exception", RuntimeError

      it "calls the on_error hook" do
        begin
          subject
        rescue RuntimeError
          nil
        end
        expect(on_error).to have_received(:call)
      end
    end

    context "when backup is not configured" do
      it "does not raise an exception" do
        expect { subject }.not_to raise_error
      end

      it "calls the before hook" do
        subject
        expect(before_hook).to have_received(:call)
      end

      it "calls the after hook" do
        subject
        expect(after_hook).to have_received(:call)
      end
    end

    context "when backup configured" do
      let(:backup_config) { instance_double(Rustic::Configs::Backup, before: before_backup_hook, after: after_backup_hook, paths: ["/"], one_fs: true, excluded_paths: []) }

      let(:before_backup_hook) { instance_double(Proc, call: true) }
      let(:after_backup_hook) { instance_double(Proc, call: true) }

      before do
        allow(Rustic::Wrapper).to receive(:new).and_return(wrapper)
      end

      it "does not raise an exception" do
        expect { subject }.not_to raise_error
      end

      it "calls Rustic::Wrapper twice" do
        subject
        expect(wrapper).to have_received(:run).once
      end

      it "calls the before hook" do
        subject
        expect(before_hook).to have_received(:call)
      end

      it "calls the after hook" do
        subject
        expect(after_hook).to have_received(:call)
      end
    end
  end
end
