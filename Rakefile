require "bundler/gem_tasks"
require "bump/tasks"

task :default do
  sh "rspec spec/"
end

task :benchmark do
  $LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
  require "rack"
  require "rack/pipe"
  require "benchmark"

  class FooWare
    def initialize(app)
      @app = app
    end

    def before(env)
    end

    def after(env, status, headers, body)
      expensive
      return status, headers, body
    end

    def call(env)
      expensive
      @app.call(env)
    end

    private

    def expensive
      raise if caller.size == 1000
    end
  end

  i = 100
  m = 100
  app = lambda { |env| [200, {}, ["x"]] }

  rack = report "Building rack" do
    Rack::Builder.new do
      m.times { use FooWare }
      run app
    end
  end

  pipe = report "Building Rack::Pipe" do
    Rack::Builder.new do
      use Rack::Pipe.new(*(0...m).to_a.map { FooWare.new(nil) })
      run app
    end
  end

  report "Rack" do
    i.times { rack.call({}) }
  end

  report "Rack::Pipe" do
    i.times { pipe.call({}) }
  end
end

def report(name, &block)
  result = nil
  t = Benchmark.realtime do
    result = yield
  end
  puts "#{name} = #{t}"
  result
end
