# frozen_string_literal: true

RSpec.describe Rustic do
  it "has a version number" do
    expect(Rustic::VERSION).not_to be nil
  end

  describe "#define" do
    subject { described_class.define(run: run, &config_block) }

    let(:config_block) do
      proc do
        repository "repository"
        password "password"
      end
    end

    context "when run is true" do
      let(:run) { true }
      let(:app) { instance_double(Rustic::Application, run: true) }

      before do
        allow(Rustic::Application).to receive(:new).and_return(app)
      end

      it "returns an instance of Rustic::Application" do
        expect(subject).to eq(app)
      end

      it "calls Rustic::Application#run" do
        subject
        expect(app).to have_received(:run)
      end
    end

    context "when run is false" do
      let(:run) { false }

      it "returns an instance of Rustic::Application" do
        expect(subject).to be_an_instance_of(Rustic::Application)
      end
    end
  end
end
