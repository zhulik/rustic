# frozen_string_literal: true

RSpec.describe Rustic::Script::CommandBuilder do
  let(:builder) { described_class.new(command, config) }
  let(:config) { instance_double(Rustic::Script::Config, repository: "repository", password: password, password_file: password_file, restic_path: "restic", backup_config: backup_config, check_config: check_config) }

  let(:password) { "password" }
  let(:password_file) { nil }

  let(:backup_config) { nil }
  let(:check_config) { nil }

  describe "#build" do
    subject { builder.build }

    context "when the command is unknown" do
      let(:command) { "unknown" }

      include_examples "raises an exception", described_class::UnknownCommandError
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

        include_examples "raises an exception", described_class::UnknownPasswordMethodError
      end
    end

    context "when the command is backup" do
      let(:command) { "backup" }

      context "when backup is not configured" do
        let(:backup_config) { nil }

        include_examples "raises an exception", described_class::MissingConfigError, "Command `backup` misses it's configuration"
      end

      context "when backup is configred" do
        let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: one_fs, paths: paths, excluded_paths: excluded_paths) }
        let(:one_fs) { false }
        let(:paths) { ["/", "/home"] }
        let(:excluded_paths) { ["/usr", "var"] }

        context "when one_fs is enabled" do
          let(:one_fs) { true }

          it "returns a command and env variables" do
            expect(subject).to eq([["restic", "-r", "repository", "backup", "-x", "/", "/home", "--exclude", "/usr", "--exclude", "var"], { "RESTIC_PASSWORD" => "password" }])
          end
        end

        context "when paths is empty" do
          let(:paths) { [] }

          include_examples "raises an exception", described_class::MalformedConfigError, "Backup paths cannot be empty"
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

    context "when the command is check" do
      let(:command) { "check" }

      context "when check is not configured" do
        let(:check_config) { nil }

        include_examples "raises an exception", described_class::MissingConfigError, "Command `check` misses it's configuration"
      end

      context "when check is configured" do
        let(:check_config) { instance_double(Rustic::Script::CheckConfig, check_unused: check_unused, read_data_subset: read_data_subset, with_cache: with_cache) }
        let(:check_unused) { false }
        let(:read_data_subset) { nil }
        let(:with_cache) { nil }

        context "when check_unused is enabled" do
          let(:check_unused) { true }

          it "returns a command and env variables" do
            expect(subject).to eq([["restic", "-r", "repository", "check", "--check-unused"], { "RESTIC_PASSWORD" => "password" }])
          end
        end

        context "when with_cache is enabled" do
          let(:with_cache) { true }

          it "returns a command and env variables" do
            expect(subject).to eq([["restic", "-r", "repository", "check", "--with-cache"], { "RESTIC_PASSWORD" => "password" }])
          end
        end

        context "when read_data_subset is 50" do
          let(:read_data_subset) { 50 }

          it "returns a command and env variables" do
            expect(subject).to eq([["restic", "-r", "repository", "check", "--read-data-subset=50%"], { "RESTIC_PASSWORD" => "password" }])
          end
        end

        context "when read_data_subset is 100" do
          let(:read_data_subset) { 100 }

          it "returns a command and env variables" do
            expect(subject).to eq([["restic", "-r", "repository", "check", "--read-data"], { "RESTIC_PASSWORD" => "password" }])
          end
        end
      end
    end
  end
end
