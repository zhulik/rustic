# frozen_string_literal: true

RSpec.describe Rustic::Application do
  let(:cli) { described_class.new(config) }
  let(:config) { instance_double(Rustic::Script::Config, repository: "repository", password: password, restic_path: "restic", backup_config: backup_config) }
  let(:password) { "password" }
  let(:password_file) { nil }
  let(:backup_config) { nil }

  describe "#run" do
    subject { cli.run(argv) }

    let(:wrapper) { instance_double(Rustic::Wrapper, run: true) }

    context "when the command is snapshots" do
      let(:argv) { ["snapshots"] }

      it "calls Rustic::Wrapper#run" do
        allow(Rustic::Wrapper).to receive(:new).with(["restic", "-r", "repository", "snapshots"], { "RESTIC_PASSWORD" => "password" }).and_return(wrapper)
        subject
        expect(wrapper).to have_received(:run)
      end
    end

    context "when the command is backup" do
      let(:argv) { ["backup"] }

      let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: true, paths: ["/home"], excluded_paths: []) }

      it "calls Rustic::Wrapper#run" do
        allow(Rustic::Wrapper).to receive(:new).with(["restic", "-r", "repository", "backup", "-x", "/home"], { "RESTIC_PASSWORD" => "password" }).and_return(wrapper)
        subject
        expect(wrapper).to have_received(:run)
      end
    end

    context "when the command is nil" do
      let(:argv) { [] }

      let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: true, paths: ["/home"], excluded_paths: []) }

      it "calls Rustic::Wrapper#run" do
        allow(Rustic::Wrapper).to receive(:new).with(["restic", "-r", "repository", "backup", "-x", "/home"], { "RESTIC_PASSWORD" => "password" }).and_return(wrapper)
        subject
        expect(wrapper).to have_received(:run)
      end
    end

    context "when the command is unknown" do
      let(:argv) { ["unknown"] }

      include_examples "raises an exception", described_class::UnknownCommandError
    end
  end
end
