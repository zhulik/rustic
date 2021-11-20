# frozen_string_literal: true

RSpec.describe Rustic::Script::Validator do
  let(:validator) { described_class.new(config) }
  let(:config) { instance_double(Rustic::Script::Config, repository: repository, password: password, password_file: password_file, restic_path: restic_path, backup_config: backup_config, strict_validation: strict) }

  let(:restic_path) { "restic" }
  let(:repository) { "repository" }
  let(:backup_config) { nil }
  let(:password) { "password" }
  let(:password_file) { "./password.txt" }
  let(:strict) { false }

  describe "#validate" do
    subject { validator.validate }

    context "when restic is in PATH" do
      before do
        allow(File).to receive(:which).with("restic").and_return("/bin/restic")
      end

      context "when config is empty" do
        let(:restic_path) { nil }
        let(:repository) { nil }
        let(:password) { nil }
        let(:password_file) { nil }

        it "returns errors" do
          expect(subject.first).to eq(["restic path is miconfigured: 'nil'", "repository is not configured", "password is not configured"])
        end

        it "returns warnings" do
          expect(subject[1]).to eq(["backup is not configured"])
        end
      end

      context "when strict mode is enabled" do
        let(:strict) { true }

        context "when backup and exclude paths are sorted and have no duplicates" do
          let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: true, paths: ["/", "/home"], excluded_paths: ["/etc", "/var"]) }

          it "returns no errors" do
            expect(subject.first).to be_empty
          end

          it "returns no warnings" do
            expect(subject[1]).to be_empty
          end
        end

        context "when backup and exclude paths are not sorted but have no duplicates" do
          let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: true, paths: ["/home", "/"], excluded_paths: ["/var", "/etc"]) }

          it "returns errors" do
            expect(subject.first).to eq(["backup paths must be alphabetically sorted", "excluded paths must be alphabetically sorted"])
          end

          it "returns no warnings" do
            expect(subject[1]).to be_empty
          end
        end

        context "when backup and exclude paths are not sorted and have duplicates" do
          let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: true, paths: ["/", "/home", "/"], excluded_paths: ["/etc", "/var", "/etc"]) }

          it "returns errors" do
            expect(subject.first).to eq(["backup paths must be alphabetically sorted", "backup paths contain duplicates", "excluded paths must be alphabetically sorted", "excluded paths contain duplicates"])
          end

          it "returns no warnings" do
            expect(subject[1]).to be_empty
          end
        end
      end

      context "when strict mode is disabled" do
        let(:strict) { false }

        context "when backup and exclude paths are sorted and have no duplicates" do
          let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: true, paths: ["/", "/home"], excluded_paths: ["/etc", "/var"]) }

          it "returns no errors" do
            expect(subject.first).to be_empty
          end

          it "returns no warnings" do
            expect(subject[1]).to be_empty
          end
        end

        context "when backup and exclude paths are not sorted but have no duplicates" do
          let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: true, paths: ["/home", "/"], excluded_paths: ["/var", "/etc"]) }

          it "returns no errors" do
            expect(subject.first).to be_empty
          end

          it "returns no warnings" do
            expect(subject[1]).to be_empty
          end
        end

        context "when backup and exclude paths are not sorted and have duplicates" do
          let(:backup_config) { instance_double(Rustic::Script::BackupConfig, one_fs: true, paths: ["/", "/home", "/"], excluded_paths: ["/etc", "/var", "/etc"]) }

          it "returns no errors" do
            expect(subject.first).to be_empty
          end

          it "returns no warnings" do
            expect(subject[1]).to be_empty
          end
        end
      end
    end

    context "when restic is not in PATH" do
      before do
        allow(File).to receive(:which).with("restic").and_return(nil)
      end

      it "returns errors" do
        expect(subject.first).to eq(["restic path is miconfigured: '\"restic\"'"])
      end

      it "returns warnings" do
        expect(subject[1]).to eq(["backup is not configured"])
      end
    end
  end
end
