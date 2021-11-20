# frozen_string_literal: true

RSpec.describe Rustic::CommandBuilders::Forget do
  let(:config) { instance_double(Rustic::Config, forget_config: forget_config) }

  describe "#build" do
    subject { builder.build }

    let(:builder) { described_class.new(config) }

    context "when forget is not configured" do
      let(:forget_config) { nil }

      include_examples "raises an exception", Rustic::CommandBuilder::MissingConfigError, "Command `forget` misses it's configuration"
    end

    context "when forget is configured" do
      let(:forget_config) { instance_double(Rustic::Configs::Forget, prune: prune, keep_last: keep_last, keep_weekly: keep_weekly, keep_monthly: keep_monthly) }
      let(:prune) { false }
      let(:keep_last) { 1 }
      let(:keep_weekly) { 2 }
      let(:keep_monthly) { 3 }

      context "when prune is disabled" do
        it "returns a command" do
          expect(subject).to eq(["forget", "--keep-last=1", "--keep-weekly=2", "--keep-monthly=3"])
        end
      end

      context "when prune is enabled" do
        let(:prune) { true }
        let(:keep_monthly) { nil }

        it "returns a command" do
          expect(subject).to eq(["forget", "--keep-last=1", "--keep-weekly=2", "--prune"])
        end
      end
    end
  end
end
