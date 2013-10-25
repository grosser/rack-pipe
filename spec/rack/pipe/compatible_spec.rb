require "spec_helper"
require "rack/pipe/compatible"

describe Rack::Pipe::Compatible do
  let(:app) { lambda { |env| [200, {}, ["APP"]] } }

  it "can return from before" do
    ware = Class.new(Rack::Pipe::Compatible) do
      def before(env)
        [200, env, ["BEFORE"]]
      end
    end
    ware.new(app).call({:x => 1}).should == [200, {:x => 1}, ["BEFORE"]]
  end

  it "can pass through before" do
    ware = Class.new(Rack::Pipe::Compatible) do
      def before(env)
      end
    end
    ware.new(app).call({:x => 1}).should == [200, {}, ["APP"]]
  end

  it "can modify in after" do
    ware = Class.new(Rack::Pipe::Compatible) do
      def after(env, status, headers, body)
        body = ["AFTER"]
        return status, headers, body
      end
    end
    ware.new(app).call({:x => 1}).should == [200, {}, ["AFTER"]]
  end
end
