# frozen_string_literal: true

RSpec.describe Rustic::Script::Hooks do
  let(:hooks) { described_class.new(config) }
  let(:config) { instance_double(Rustic::Script::Config, before: before_hook, after: after_hook) }
  let(:before_hook) { instance_double(Proc, call: true) }
  let(:after_hook) { instance_double(Proc, call: true) }

  describe "#with_hooks" do
    context "when no block given" do
      it "raises and exception and does not call any hooks" do # rubocop:disable RSpec/MultipleExpectations
        expect { hooks.with_hooks }.to raise_error(ArgumentError)
        expect(before_hook).not_to have_received(:call)
        expect(after_hook).not_to have_received(:call)
      end
    end

    context "when no errors occurred" do
      it "yields control" do
        expect do |b|
          hooks.with_hooks(&b)
        end.to yield_control.once
      end

      it "calls before and after hooks" do # rubocop:disable RSpec/MultipleExpectations
        hooks.with_hooks { "TEST" }
        expect(before_hook).to have_received(:call)
        expect(after_hook).to have_received(:call)
      end
    end

    context "when an errors occurred in the before hook" do
      let(:before_hook) { proc { raise RuntimeError } }

      it "raises an exception and does not call the after hook" do # rubocop:disable RSpec/MultipleExpectations
        expect { hooks.with_hooks { "TEST" } }.to raise_error(RuntimeError)
        expect(after_hook).not_to have_received(:call)
      end

      it "does not yield control" do
        expect do |b|
          hooks.with_hooks(&b)
        rescue RuntimeError
          nil
        end.not_to yield_control.once
      end
    end

    context "when an errors occurred in the after hook" do
      let(:after_hook) { proc { raise RuntimeError } }

      it "yields control" do
        expect do |b|
          hooks.with_hooks(&b)
        rescue RuntimeError
          nil
        end.to yield_control.once
      end

      it "raises an exception and calls before hook" do # rubocop:disable RSpec/MultipleExpectations
        expect { hooks.with_hooks { raise RuntimeError } }.to raise_error(RuntimeError)
        expect(before_hook).to have_received(:call)
      end
    end

    context "when an errors occurred in the passed block" do
      it "calls the before hook, but does not call the after hook" do  # rubocop:disable RSpec/MultipleExpectations
        expect { hooks.with_hooks { raise RuntimeError } }.to raise_error(RuntimeError)
        expect(before_hook).to have_received(:call)
        expect(after_hook).not_to have_received(:call)
      end
    end
  end
end
