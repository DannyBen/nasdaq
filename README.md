# Nasdaq Data Link API and Command Line

[![Gem Version](https://badge.fury.io/rb/nasdaq.svg)](https://badge.fury.io/rb/nasdaq)
[![Build Status](https://github.com/DannyBen/nasdaq/workflows/Test/badge.svg)](https://github.com/DannyBen/nasdaq/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/1d68eed3be3481f48066/maintainability)](https://codeclimate.com/github/DannyBen/nasdaq/maintainability)

---

Lightweight ruby library and command line interface for accessing the 
[Nasdaq Data Link API][1] (formerly Quandl) with direct access to all of its
endpoints.

**This gem is not affiliated with Nasdaq or with Quandl.**

---

## Install

```
$ gem install nasdaq
```

Or with bundler:

```ruby
gem 'nasdaq'
```


## Features

* Easy to use interface.
* Use as a library or through the command line.
* Access any of the API endpoints directly.
* Display output in various formats.
* Save output to a file.
* Includes a built in file cache (disabled by default).


## Usage

First, require and initialize with your-api-key

```ruby
require 'nasdaq'
nasdaq = Nasdaq::API.new 'your-api-key'
```

Now, you can access any API endpoint with any optional parameter, like
this:

```ruby
result = nasdaq.get "datasets/WIKI/AAPL", rows: 3 # => Hash
```

In addition, for convenience, you can use the first part of the endpoint as
a method name, like this:

```ruby
result = nasdaq.datasets "WIKI/AAPL", rows: 3
```

In other words, these calls are the same:

```ruby
nasdaq.get 'endpoint', param: value
nasdaq.endpoint, param: value
```

as well as these two:

```ruby
nasdaq.get 'endpoint/sub', param: value
nasdaq.endpoint 'sub', param: value
```

By default, you will get a ruby hash in return. If you wish to have more 
control over the response, use the `get!` method instead:

```ruby
result = nasdaq.get! "datasets/WIKI/AAPL", rows: 3

# Request Object
p payload.request.class
# => HTTParty::Request

# Response Object
p payload.response.class
# => Net::HTTPOK

p payload.response.body
# => JSON string

p payload.response.code
# => 200

p payload.response.msg
# => OK

# Headers Object
p payload.headers
# => Hash with headers

# Parsed Response Object
p payload.parsed_response
# => Hash with HTTParty parsed response 
#    (this is the content returned with #get)
```

You can get the response as CSV by calling `get_csv`:

```ruby
result = nasdaq.get_csv "datasets/WIKI/AAPL", rows: 3
# => CSV string
```

To save the output directly to a file, use the `save` method:

```ruby
nasdaq.save "filename.json", "datasets/WIKI/AAPL", rows: 3
```

Or, to save CSV, use the `save_csv` method:

```ruby
nasdaq.save_csv "filename.csv", "datasets/WIKI/AAPL", rows: 3
```


## Command Line

The command line utility `nasdaq` acts in a similar way. To use your-api-key,
simply set it in the environment variables `NASDAQ_KEY`:

```
$ export NASDAQ_KEY=your_key
```

These commands are available:

```bash
$ nasdaq get PATH [PARAMS...]        # print the output.  
$ nasdaq pretty PATH [PARAMS...]     # print a pretty JSON.  
$ nasdaq see PATH [PARAMS...]        # print a colored output.  
$ nasdaq url PATH [PARAMS...]        # show the constructed URL.  
$ nasdaq save FILE PATH [PARAMS...]  # save the output to a file.  
```

Run `nasdaq --help` for more information, or view the [full usage help][2].

Examples:

```bash
# Shows the first two databases 
$ nasdaq see databases per_page:2

# Or more compactly, as CSV
$ nasdaq get databases per_page:2

# Prints CSV to screen (CSV is the default in the command line)
$ nasdaq get datasets/WIKI/AAPL

# Prints JSON instead
$ nasdaq get datasets/WIKI/AAPL.json

# Pass arguments using the same syntax - key:value
$ nasdaq get datasets/WIKI/AAPL rows:5

# Pass arguments that require spaces
$ nasdaq get datasets.json "query:qqq index"

# Prints a colored output
$ nasdaq see datasets/WIKI/AAPL rows:5

# Saves a file
$ nasdaq save output.csv datasets/WIKI/AAPL rows:5

# Shows the underlying URL for the request, good for debugging
$ nasdaq url datasets/WIKI/AAPL rows:5
# => https://data.nasdaq.com/api/v3/datasets/WIKI/AAPL.csv?api_key=YOUR_KEY&rows=5
```

## Caching

The Nasdaq library uses the [Lightly][3] gem for automatic HTTP caching.
To take the path of least surprises, caching is disabled by default.

You can enable and customize it by either passing options on 
initialization, or by accessing the `Lightly` object directly at 
a later stage.

```ruby
nasdaq = Nasdaq::API.new 'your-api-key', use_cache: true
nasdaq = Nasdaq::API.new 'your-api-key', use_cache: true, cache_dir: 'tmp'
nasdaq = Nasdaq::API.new 'your-api-key', use_cache: true, cache_life: 120

# or 

nasdaq = Nasdaq::API.new 'your-api-key'
nasdaq.cache.enable
nasdaq.cache.dir = 'tmp/cache'   # Change cache folder
nasdaq.cache.life = 120          # Change cache life to 2 minutes
```

To enable caching for the command line, simply set one or both of 
these environment variables:

```bash
$ export NASDAQ_CACHE_DIR=cache   # default: 'cache'
$ export NASDAQ_CACHE_LIFE=120    # default: 3600 (1 hour)
$ nasdaq get datasets/WIKI/AAPL
# => This call will be cached
```


## Command Line Demo

![Demo](https://raw.githubusercontent.com/DannyBen/nasdaq/master/suppoer/demmo/cast.gif "Demo")

[1]: https://docs.data.nasdaq.com/docs/getting-started
[2]: https://github.com/DannyBen/nasdaq/blob/master/lib/nasdaq/docopt.txt
[3]: https://github.com/DannyBen/lightly

