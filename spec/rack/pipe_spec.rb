require "spec_helper"

describe Rack::Pipe do
  it "has a VERSION" do
    Rack::Pipe::VERSION.should =~ /^[\.\da-z]+$/
  end
end
