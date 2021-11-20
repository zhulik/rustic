# frozen_string_literal: true

RSpec.describe Rustic::HooksExt do
  let(:klass) do
    Class.new do
      include Rustic::HooksExt
    end
  end
  let(:config) { klass.new }

  describe "#before" do
    it "assigns and returns the `before` hook" do
      block = proc {}

      expect do
        config.before(&block)
      end.to change(config, :before).from(nil).to(block)
    end
  end

  describe "#after" do
    it "assigns and returns the `before` hook" do
      block = proc {}

      expect do
        config.after(&block)
      end.to change(config, :after).from(nil).to(block)
    end
  end
end
