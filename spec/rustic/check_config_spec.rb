# frozen_string_literal: true

RSpec.describe Rustic::CheckConfig do
  let(:config) { described_class.new }

  describe "defaults" do
    it "has reasonable defaults" do # rubocop:disable RSpec/MultipleExpectations
      expect(config.check_unused).to be_falsey
      expect(config.read_data_subset).to be_nil
      expect(config.with_cache).to eq(false)
    end
  end

  describe "#check_unused!" do
    it "assigns the check_unused flag" do
      expect do
        config.check_unused!
      end.to change(config, :check_unused).from(false).to(true)
    end
  end

  describe "#with_cache!" do
    it "assigns the with_cache flag" do
      expect do
        config.with_cache!
      end.to change(config, :with_cache).from(false).to(true)
    end
  end

  describe "#subset" do
    subject { config.subset(percent) }

    context "when percennt is > 0 and <= 100" do
      let(:percent) { 20 }

      it "assigns the read_data_subset" do
        expect do
          subject
        end.to change(config, :read_data_subset).from(nil).to(20)
      end
    end

    context "when percent is <=0" do
      let(:percent) { 0 }

      include_examples "raises an exception", ArgumentError, "percent must be > 0 and <= 100. Given: 0"
    end

    context "when percent is > 100" do
      let(:percent) { 101 }

      include_examples "raises an exception", ArgumentError, "percent must be > 0 and <= 100. Given: 101"
    end
  end
end
