# frozen_string_literal: true

RSpec.describe Rustic::CommandBuilders::Check do
  let(:config) { instance_double(Rustic::Config, check_config: check_config) }

  describe "#build" do
    subject { builder.build }

    let(:builder) { described_class.new(config) }

    context "when check is not configured" do
      let(:check_config) { nil }

      it "returns a command" do
        expect(subject).to eq(["check"])
      end
    end

    context "when check is configured" do
      let(:check_config) { instance_double(Rustic::Configs::Check, check_unused: check_unused, read_data_subset: read_data_subset, with_cache: with_cache) }
      let(:check_unused) { false }
      let(:read_data_subset) { nil }
      let(:with_cache) { nil }

      context "when check_unused is enabled" do
        let(:check_unused) { true }

        it "returns a command" do
          expect(subject).to eq(["check", "--check-unused"])
        end
      end

      context "when with_cache is enabled" do
        let(:with_cache) { true }

        it "returns a command" do
          expect(subject).to eq(["check", "--with-cache"])
        end
      end

      context "when read_data_subset is 50" do
        let(:read_data_subset) { 50 }

        it "returns a command" do
          expect(subject).to eq(["check", "--read-data-subset=50%"])
        end
      end

      context "when read_data_subset is 100" do
        let(:read_data_subset) { 100 }

        it "returns a command" do
          expect(subject).to eq(["check", "--read-data"])
        end
      end
    end
  end
end
