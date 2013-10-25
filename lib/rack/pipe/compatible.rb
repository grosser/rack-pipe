module Rack
  module Pipe
    class Compatible
      def initialize(app)
        @app = app
        @before = respond_to?(:before)
        @after = respond_to?(:after)
      end

      def call(env)
        if @before
          status, headers, body = before(env)
          return status, headers, body if status
        end

        status, headers, body = @app.call(env)

        if @after
          status, headers, body = after(env, status, headers, body)
        end

        return status, headers, body
      end
    end
  end
end
