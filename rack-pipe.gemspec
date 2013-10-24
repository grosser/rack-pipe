$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "rack-pipe"
require "#{name.gsub("-","/")}/version"

Gem::Specification.new name, Rack::Pipe::VERSION do |s|
  s.summary = "Rack without the giant callstack"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/`.split("\n")
  s.license = "MIT"
  cert = File.expand_path("~/.ssh/gem-private-key-grosser.pem")
  if File.exist?(cert)
    s.signing_key = cert
    s.cert_chain = ["gem-public_cert.pem"]
  end
end
