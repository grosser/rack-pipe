module Rack
  module Pipe
    class Pipe
      def initialize(*pipe_wares)
        @before = pipe_wares.select { |p| p.respond_to?(:before) }
        @after = pipe_wares.select { |p| p.respond_to?(:after) }.reverse!
      end

      def new(app)
        @app = app
        self
      end

      def call(env)
        @before.each do |ware|
          status, headers, body = ware.before(env)
          return status, headers, body if status
        end

        status, headers, body = @app.call(env)

        @after.each do |ware|
          status, headers, body = ware.after(env, status, headers, body)
        end

        return status, headers, body
      end
    end
  end
end
