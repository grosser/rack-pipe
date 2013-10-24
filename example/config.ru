$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'rack/pipe'

class FooWare
  # stop the request or just pass through by returning nil
  def before(env)
    [400, {}, ["Bad request!"]] if env["QUERY_STRING"].include?("stop")
  end

  # augment the response
  def after(env, status, headers, body)
    body << "\nGood for you!" if status == 200
    [status, headers, body]
  end
end

use Rack::Pipe.new(
  # put all your pipe-wares here
  FooWare.new,
  FooWare.new
)

run lambda { |env| [200, {}, ["Success"]] }
