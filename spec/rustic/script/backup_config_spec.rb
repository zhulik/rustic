# frozen_string_literal: true

RSpec.describe Rustic::Script::BackupConfig do
  let(:config) { described_class.new }

  describe "defaults" do
    it "has reasonable defaults" do # rubocop:disable RSpec/MultipleExpectations
      expect(config.one_fs).to be_falsey
      expect(config.excluded_paths).to be_empty
      expect(config.paths).to be_empty
    end
  end

  describe "#backup" do
    context "when arguments passed" do
      it "assigns new backup paths" do # rubocop:disable RSpec/MultipleExpectations
        config.backup("/")
        expect(config.paths).to eq(["/"])
        config.backup("/etc")
        expect(config.paths).to eq(["/etc"])
      end
    end

    context "when arguments are not passed" do
      it "raises ArgumentError" do
        expect { config.backup }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#exclude" do
    context "when arguments passed" do
      it "assigns new exclude paths" do # rubocop:disable RSpec/MultipleExpectations
        config.exclude("/home")
        expect(config.excluded_paths).to eq(["/home"])
        config.exclude("/etc")
        expect(config.excluded_paths).to eq(["/etc"])
      end
    end

    context "when arguments are not passed" do
      it "raises ArgumentError" do
        expect { config.exclude }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#one_fs!" do
    it "assigns the one_fs flag" do
      config.one_fs!
      expect(config.one_fs).to be_truthy
    end
  end
end
