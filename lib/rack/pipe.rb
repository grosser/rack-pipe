require "rack/pipe/version"
require "rack/pipe/pipe"

module Rack
  module Pipe
    def self.build(*args)
      Pipe.new(*args)
    end
  end
end
