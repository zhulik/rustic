# frozen_string_literal: true

RSpec.describe Rustic do
  it "has a version number" do
    expect(Rustic::VERSION).not_to be nil
  end

  describe "#define" do
    it "works" do
      described_class.define(run: false) do
        repository "repo"
      end
    end
  end
end
