# frozen_string_literal: true

RSpec.describe SimpleForex do
 
  # Default test
 it "has a version number" do
    expect(SimpleForex::VERSION).not_to be nil
  end

  it "all_currencies() provides at least 168 currencies" do
    expect(all_currencies.length).to be >= 168 
  end

  # Default test
  it "does something useful" do
    expect(true).to eq(true)
  end
end
