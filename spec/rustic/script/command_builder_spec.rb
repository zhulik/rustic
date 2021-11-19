# frozen_string_literal: true

RSpec.describe Rustic::Script::CommandBuilder do
  let(:builder) { described_class.new(command, config) }
  let(:config) { instance_double(Rustic::Script::Config, repository: "repository", password: password, password_file: password_file, restic_path: "restic", backup_config: backup_config) }
  let(:password) { "password" }
  let(:password_file) { nil }
  let(:backup_config) { nil }

  describe "#build" do
    subject { builder.build }

    context "when the command is unknown" do
      let(:command) { "unknown" }

      it "raises an exception" do
        expect { subject }.to raise_error(described_class::UnknownCommandError)
      end
    end

    context "when the command is snapshots" do
      let(:command) { "snapshots" }

      context "when password is passed" do
        it "returns a command and env variables" do
          expect(subject).to eq([["restic", "-r", "repository", "snapshots"], { "RESTIC_PASSWORD" => "password" }])
        end
      end

      context "when password_file is passed" do
        let(:password) { nil }
        let(:password_file) { "./password.txt" }

        it "returns a command and env variables" do
          expect(subject).to eq([["restic", "-r", "repository", "snapshots"], { "RESTIC_PASSWORD_FILE" => "./password.txt" }])
        end
      end

      context "when password_file and password are empty" do
        let(:password) { nil }
        let(:password_file) { nil }

        it "raises an exception" do
          expect { subject }.to raise_error(described_class::UnknownPasswordMethodError)
        end
      end
    end

    context "when the command is backup" do
      let(:command) { "backup" }
      let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: one_fs, paths: paths, excluded_paths: excluded_paths) }
      let(:one_fs) { false }
      let(:paths) { ["/", "/home"] }
      let(:excluded_paths) { ["/usr", "var"] }

      context "when backup is not configured" do
        let(:backup_config) { nil }

        it "raises an exception" do
          expect { subject }.to raise_error(described_class::MissingConfigError, "Command `backup` misses it's configuration")
        end
      end

      context "when backup is configred" do
        context "when on_fs is enabled" do
          let(:one_fs) { true }

          it "returns a command and env variables" do
            expect(subject).to eq([["restic", "-r", "repository", "backup", "-x", "/", "/home", "--exclude", "/usr", "--exclude", "var"], { "RESTIC_PASSWORD" => "password" }])
          end
        end

        context "when paths is empty" do
          let(:paths) { [] }

          it "raises an exception" do
            expect { subject }.to raise_error(described_class::MalformedConfigError, "Backup paths cannot be empty")
          end
        end

        context "when excuded paths is empty" do
          let(:excluded_paths) { [] }

          it "returns a command and env variables" do
            expect(subject).to eq([["restic", "-r", "repository", "backup", "/", "/home"], { "RESTIC_PASSWORD" => "password" }])
          end
        end

        context "when on_fs is not enabled" do
          it "returns a command and env variables" do
            expect(subject).to eq([["restic", "-r", "repository", "backup", "/", "/home", "--exclude", "/usr", "--exclude", "var"], { "RESTIC_PASSWORD" => "password" }])
          end
        end
      end
    end
  end
end
