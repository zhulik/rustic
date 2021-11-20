# frozen_string_literal: true

RSpec.describe Rustic::CommandBuilder do
  let(:builder) { described_class.new(command, config) }
  let(:config) { instance_double(Rustic::Config, repository: "repository", restic_path: "restic", password: password, password_file: password_file) }

  let(:password) { "password" }
  let(:password_file) { nil }

  describe "#build" do
    subject { builder.build }

    context "when the command is unknown" do
      let(:command) { "unknown" }

      include_examples "raises an exception", described_class::UnknownCommandError
    end

    context "when the command is snapshots" do
      let(:command) { "snapshots" }

      context "when password is set" do
        it "returns a command and env variables" do
          expect(subject).to eq([["restic", "-r", "repository", "snapshots"], { "RESTIC_PASSWORD" => "password" }])
        end
      end

      context "when password_file is set" do
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
  end
end
