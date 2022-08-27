# frozen_string_literal: true

RSpec.describe Rustic::CommandBuilders::Backup do
  let(:builder) { described_class.new(config) }
  let(:config) { instance_double(Rustic::Config, backup_config: backup_config) }

  let(:backup_config) { nil }

  describe "#build" do
    subject { builder.build }

    context "when backup is not configured" do
      let(:backup_config) { nil }

      include_examples "raises an exception", Rustic::CommandBuilder::MissingConfigError, "Command `backup` misses it's configuration"
    end

    context "when backup is configred" do
      let(:backup_config) { instance_double(Rustic::Configs::Backup, one_fs: one_fs, paths: paths, excluded_paths: excluded_paths, compression_mode: "auto") }
      let(:one_fs) { false }
      let(:paths) { ["/", "/home"] }
      let(:excluded_paths) { ["/usr", "var"] }

      context "when one_fs is enabled" do
        let(:one_fs) { true }

        it "returns a command" do
          expect(subject).to eq(["--compression", "auto", "backup", "-x", "/", "/home", "--exclude", "/usr", "--exclude", "var"])
        end
      end

      context "when paths is empty" do
        let(:paths) { [] }

        include_examples "raises an exception", Rustic::CommandBuilder::MalformedConfigError, "Backup paths cannot be empty"
      end

      context "when excuded paths is empty" do
        let(:excluded_paths) { [] }

        it "returns a command" do
          expect(subject).to eq(["--compression", "auto", "backup", "/", "/home"])
        end
      end

      context "when on_fs is not enabled" do
        it "returns a command" do
          expect(subject).to eq(["--compression", "auto", "backup", "/", "/home", "--exclude", "/usr", "--exclude", "var"])
        end
      end
    end
  end
end
