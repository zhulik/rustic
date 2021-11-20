# frozen_string_literal: true

RSpec.describe Rustic::Configs::Forget do
  let(:config) { described_class.new }

  describe "defaults" do
    it "has reasonable defaults" do
      expect(config.prune).to be_falsey
    end
  end

  describe "#prune!" do
    it "assigns the prune flag" do
      expect do
        config.prune!
      end.to change(config, :prune).from(false).to(true)
    end
  end

  describe "#keep" do
    subject { config.keep(last: last, weekly: weekly, monthly: monthly) }

    let(:last) { nil }
    let(:weekly) { nil }
    let(:monthly) { nil }

    context "when all options are nils" do
      include_examples "raises an exception", ArgumentError, "keep options must be provided"
    end

    context "when options are provided" do
      let(:last) { 1 }
      let(:weekly) { 2 }
      let(:monthly) { 3 }

      it "assigns keep_last" do
        expect do
          subject
        end.to change(config, :keep_last).from(nil).to(1)
      end

      it "assigns keep_weekly" do
        expect do
          subject
        end.to change(config, :keep_weekly).from(nil).to(2)
      end

      it "assigns keep_monthly" do
        expect do
          subject
        end.to change(config, :keep_monthly).from(nil).to(3)
      end
    end
  end
end
