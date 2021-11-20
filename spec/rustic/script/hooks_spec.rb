# frozen_string_literal: true

RSpec.describe Rustic::Script::Hooks do
  let(:hooks) { described_class.new(config) }
  let(:config) { instance_double(Rustic::Script::Config, before: before_hook, after: after_hook) }
  let(:before_hook) { instance_double(Proc, call: true) }
  let(:after_hook) { instance_double(Proc, call: true) }

  describe "#with_hooks" do
    subject { hooks.with_hooks { "TEST" } }

    context "when no block given" do
      subject { hooks.with_hooks }

      include_examples "raises an exception", ArgumentError

      it "does not call the before hook" do
        subject rescue nil # rubocop:disable Style/RescueModifier
        expect(before_hook).not_to have_received(:call)
      end

      it "does not call the after hook" do
        subject rescue nil # rubocop:disable Style/RescueModifier
        expect(after_hook).not_to have_received(:call)
      end
    end

    context "when no errors occurred" do
      it "yields control" do
        expect do |b|
          hooks.with_hooks(&b)
        end.to yield_control.once
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

    context "when an errors occurred in the before hook" do
      let(:before_hook) { proc { raise RuntimeError } }

      include_examples "raises an exception", RuntimeError

      it "does not call the after hook" do
        subject rescue nil # rubocop:disable Style/RescueModifier
        expect(after_hook).not_to have_received(:call)
      end

      it "does not yield control" do
        expect do |b|
          hooks.with_hooks(&b) rescue nil # rubocop:disable Style/RescueModifier
        end.not_to yield_control.once
      end
    end

    context "when an errors occurred in the after hook" do
      let(:after_hook) { proc { raise RuntimeError } }

      it "yields control" do
        expect do |b|
          hooks.with_hooks(&b) rescue nil # rubocop:disable Style/RescueModifier
        end.to yield_control.once
      end

      include_examples "raises an exception", RuntimeError

      it "calls the before hook" do
        subject rescue nil # rubocop:disable Style/RescueModifier
        expect(before_hook).to have_received(:call)
      end
    end

    context "when an errors occurred in the passed block" do
      subject { hooks.with_hooks { raise RuntimeError } }

      include_examples "raises an exception", RuntimeError

      it "calls the before hook" do
        subject rescue nil # rubocop:disable Style/RescueModifier
        expect(before_hook).to have_received(:call)
      end

      it "does not call the after hook" do
        subject rescue nil # rubocop:disable Style/RescueModifier
        expect(after_hook).not_to have_received(:call)
      end
    end
  end
end
