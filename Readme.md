Rack without the giant callstack

Install
=======

```Bash
gem install rack-pipe
```

Usage
=====


<!-- example -->
```Ruby
# config.ru
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
```
<!-- example -->

```Bash
rackup

curl localhost:9292
Success
Good for you!
Good for you!

curl localhost:9292?stop
Bad request!
```

# Benchmark
`rake benchmark`
100 middlewares with 100 requests and 1 call to `caller`: 0.84s vs 0.39s

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/rack-pipe.png)](https://travis-ci.org/grosser/rack-pipe)
