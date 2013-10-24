require "rack/pipe/version"

module Rack
  class Pipe
    def initialize(*pipe_wares)
      @pipe_wares = pipe_wares
    end

    def new(app)
      @app = app
      self
    end

    def call(env)
      @pipe_wares.each do |ware|
        if ware.respond_to?(:before)
          status, headers, body = ware.before(env)
          return status, headers, body if status
        end
      end

      status, headers, body = @app.call(env)

      @pipe_wares.each do |ware|
        if ware.respond_to?(:after)
          status, headers, body = ware.after(env, status, headers, body)
        end
      end

      return status, headers, body
    end
  end
end
