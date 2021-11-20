# frozen_string_literal: true

RSpec.shared_examples "raises an exception" do |exception, message|
  it "raises #{Exception.name}" do
    expect { subject }.to raise_error(exception, message)
  end
end
