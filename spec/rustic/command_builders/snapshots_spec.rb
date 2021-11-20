# frozen_string_literal: true

RSpec.describe Rustic::CommandBuilders::Snapshots do
  let(:builder) { described_class.new(nil) }

  describe "#build" do
    subject { builder.build }

    it "returns a command" do
      expect(subject).to eq(["snapshots"])
    end
  end
end
