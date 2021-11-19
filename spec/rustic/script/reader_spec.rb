# frozen_string_literal: true

RSpec.describe Rustic::Script::Reader do
  let(:reader) { described_class.new("some_backup_script.rb") }

  describe "#read" do
    subject { reader.read }

    context "when the file exists" do
      before do
        allow(File).to receive(:read).with("some_backup_script.rb").and_return(script)
      end

      context "when the file is valid ruby" do
        let(:validator) { instance_double(Rustic::Script::Validator, validate!: true) }
        let(:script) do
          %(
            repository "repository"
            password "password"
          )
        end

        before do
          allow(Rustic::Script::Validator).to receive(:new).and_return(validator)
        end

        it "calls the validator" do
          subject
          expect(validator).to have_received(:validate!)
        end

        it "returns config" do
          expect(subject).to be_an_instance_of(Rustic::Script::Config)
        end
      end

      context "when the file is not in valid ruby" do
        let(:script) do
          %(
            if
          )
        end

        it "raises an exception" do
          expect { subject }.to raise_error(described_class::EvaluationError)
        end
      end

      context "when the file contains ruby error" do
        let(:script) do
          %(
            unknown_method
          )
        end

        it "raises an exception" do
          expect { subject }.to raise_error(described_class::EvaluationError)
        end
      end

      context "when the file is not in ruby" do
        let(:script) do
          %(
            def foo():
              bar()
          )
        end

        it "raises an exception" do
          expect { subject }.to raise_error(described_class::EvaluationError)
        end
      end

      context "when the file contais binary data" do
        let(:script) { SecureRandom.random_bytes }

        it "raises an exception" do
          expect { subject }.to raise_error(described_class::EvaluationError)
        end
      end
    end

    context "when file does not exist" do
      it "raises an exception" do
        expect { subject }.to raise_error(described_class::FileReadingError)
      end
    end
  end
end
