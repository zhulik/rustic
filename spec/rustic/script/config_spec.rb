# frozen_string_literal: true

RSpec.describe Rustic::Script::Config do
  let(:config) { described_class.new }

  describe "defaults" do
    it "has reasonable defaults" do
      expect(config.restic_path).to eq("restic")
    end
  end

  describe "#restic" do
    it "assigns path to the restic binary" do
      expect do
        config.restic("/bin/restic")
      end.to change(config, :restic_path).from("restic").to("/bin/restic")
    end
  end

  describe "#repository" do
    it "assigns and returns path to the restic repository" do
      expect do
        config.repository("./repository")
      end.to change(config, :repository).from(nil).to("./repository")
    end
  end

  describe "#password" do
    it "assigns and returns repository password" do
      expect do
        config.password("password")
      end.to change(config, :password).from(nil).to("password")
    end
  end

  describe "#password_file" do
    it "assigns and returns repository password file" do
      expect do
        config.password_file("./password.txt")
      end.to change(config, :password_file).from(nil).to("./password.txt")
    end
  end

  describe "#on_error" do
    it "assigns and returns the `on_error` hook" do
      block = proc {}

      expect do
        config.on_error(&block)
      end.to change(config, :on_error).from(nil).to(block)
    end
  end

  describe "#backup" do
    it "assigns backup config" do
      expect do
        config.backup { "TEST" }
      end.to change(config, :backup_config).from(nil).to(Rustic::Script::BackupConfig)
    end

    it "yields control" do
      expect do |b|
        config.backup(&b)
      end.to yield_control.once
    end
  end

  describe "#strict_validation" do
    it "assigns strict_validation" do
      expect do
        config.strict_validation!
      end.to change(config, :strict_validation).from(false).to(true)
    end
  end

  describe "#check" do
    context "when block is passed" do
      it "assigns backup config" do
        expect do
          config.check { "TEST" }
        end.to change(config, :check_config).from(nil).to(Rustic::Script::CheckConfig)
      end

      it "yields control" do
        expect do |b|
          config.check(&b)
        end.to yield_control.once
      end
    end

    context "when block is not passed" do
      it "assigns backup config" do
        expect do
          config.check
        end.to change(config, :check_config).from(nil).to(Rustic::Script::CheckConfig)
      end
    end
  end
end
