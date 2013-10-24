require "spec_helper"

describe Rack::Pipe do
  let(:simple_response) { [1, {}, ["x"]] }

  it "has a VERSION" do
    Rack::Pipe::VERSION.should =~ /^[\.\da-z]+$/
  end

  it "passes through if nothing is set up" do
    pipe = Rack::Pipe.new()
    pipe.new lambda { |env| simple_response  }
    pipe.call({}).should == simple_response
  end

  it "stops if before is returning" do
    ware = Class.new do
      def before(env)
        [200, {}, ["BEFORE"]]
      end
    end

    pipe = Rack::Pipe.new(ware.new)
    pipe.new lambda { |env| simple_response }
    pipe.call({}).should == [200, {}, ["BEFORE"]]
  end

  it "continues if before is not returning" do
    ware = Class.new do
      def before(env)
      end
    end

    pipe = Rack::Pipe.new(ware.new)
    pipe.new lambda { |env| simple_response }
    pipe.call({}).should == simple_response
  end

  it "can modify env in before" do
    ware = Class.new do
      def initialize(i)
        @i = i
      end

      def before(env)
        env["x"] ||= []
        env["x"] << @i
        false
      end
    end

    pipe = Rack::Pipe.new(ware.new(1), ware.new(2), ware.new(3))
    pipe.new lambda { |env| [200, env, ["x"]] }
    pipe.call({}).should == [200, {"x" => [1,2,3]}, ["x"]]
  end

  it "can modify response in after" do
    ware = Class.new do
      def initialize(i)
        @i = i
      end

      def after(env, status, headers, body)
        env["x"] ||= []
        env["x"] << @i
        [202, {"x" => env["x"]}, ["AFTER"]]
      end
    end

    pipe = Rack::Pipe.new(ware.new(1), ware.new(2), ware.new(3))
    pipe.new lambda { |env| simple_response }
    pipe.call({}).should == [202, {"x" => [3,2,1]}, ["AFTER"]]
  end
end
