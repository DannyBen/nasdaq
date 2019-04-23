Quata - Quandl API Library and Command Line
==================================================

[![Gem Version](https://badge.fury.io/rb/quata.svg)](https://badge.fury.io/rb/quata)
[![Build Status](https://travis-ci.com/DannyBen/quata.svg?branch=master)](https://travis-ci.com/DannyBen/quata)
[![Maintainability](https://api.codeclimate.com/v1/badges/463cd9899bf9357303ab/maintainability)](https://codeclimate.com/github/DannyBen/quata/maintainability)

---

Quata is a lightweight ruby library for accessing Quandl, and includes 
a command line interface.

It provides direct access to all of the [Quandl API][1] endpoints.

---

Install
--------------------------------------------------

```
$ gem install quata
```

Or with bundler:

```ruby
gem 'quata'
```


Features
--------------------------------------------------

* Easy to use interface.
* Use as a library or through the command line.
* Access any Quandl endpoint directly.
* Display output in various formats.
* Save output to a file, including bulk downloads.
* Includes a built in file cache (disabled by default).


Usage
--------------------------------------------------

First, require and initialize with your API key

```ruby
require 'quata'
quandl = Quata::API.new 'Your API Key'
```

Now, you can access any Quandl endpoint with any optional parameter, like
this:

```ruby
result = quandl.get "datasets/WIKI/AAPL", rows: 3 # => Hash
```

In addition, for convenience, you can use the first part of the endpoint as
a method name, like this:

```ruby
result = quandl.datasets "WIKI/AAPL", rows: 3
```

In other words, these calls are the same:

```ruby
quandl.get 'endpoint', param: value
quandl.endpoint, param: value
```

as well as these two:

```ruby
quandl.get 'endpoint/sub', param: value
quandl.endpoint 'sub', param: value
```

By default, you will get a ruby hash in return. If you wish to have more 
control over the response, use the `get!` method instead:

```ruby
result = quandl.get! "datasets/WIKI/AAPL", rows: 3

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
result = quandl.get_csv "datasets/WIKI/AAPL", rows: 3
# => CSV string
```

To save the output directly to a file, use the `save` method:

```ruby
quandl.save "filename.json", "datasets/WIKI/AAPL", rows: 3
```

Or, to save CSV, use the `save_csv` method:

```ruby
quandl.save_csv "filename.csv", "datasets/WIKI/AAPL", rows: 3
```


Command Line
--------------------------------------------------

The command line utility `quata` acts in a similar way. To use your Quandl
API key, simply set it in the environment variables `QUANDL_KEY`:

`$ export QUANDL_KEY=your_key`

These commands are available:

`$ quata get PATH [PARAMS...]` - print the output.  
`$ quata pretty PATH [PARAMS...]` - print a pretty JSON.  
`$ quata see PATH [PARAMS...]` - print a colored output.  
`$ quata url PATH [PARAMS...]` - show the constructed URL.  
`$ quata save FILE PATH [PARAMS...]` - save the output to a file.  

Run `quata --help` for more information, or view the [full usage help][2].

Examples:

```bash
# Shows the first two databases 
$ quata see databases per_page:2

# Or more compactly, as CSV
$ quata get databases per_page:2

# Prints CSV to screen (CSV is the default in the command line)
$ quata get datasets/WIKI/AAPL

# Prints JSON instead
$ quata get datasets/WIKI/AAPL.json

# Pass arguments using the same syntax - key:value
$ quata get datasets/WIKI/AAPL rows:5

# Pass arguments that require spaces
$ quata get datasets.json "query:qqq index"

# Prints a colored output
$ quata see datasets/WIKI/AAPL rows:5

# Saves a file
$ quata save output.csv datasets/WIKI/AAPL rows:5

# Shows the URL that Quata has constructed, good for debugging
$ quata url datasets/WIKI/AAPL rows:5
# => https://www.quandl.com/api/v3/datasets/WIKI/AAPL.csv?auth_token=YOUR_KEY&rows=5
```

Caching
--------------------------------------------------

Quata uses the [Lightly][3] gem for automatic HTTP caching.
To take the path of least surprises, caching is disabled by default.

You can enable and customize it by either passing options on 
initialization, or by accessing the `WebCache` object directly at 
a later stage.

```ruby
quandl = Quata::API.new 'Your API Key', use_cache: true
quandl = Quata::API.new 'Your API Key', use_cache: true, cache_dir: 'tmp'
quandl = Quata::API.new 'Your API Key', use_cache: true, cache_life: 120

# or 

quandl = Quata::API.new 'Your API Key'
quandl.cache.enable
quandl.cache.dir = 'tmp/cache'   # Change cache folder
quandl.cache.life = 120          # Change cache life to 2 minutes
```

To enable caching for the command line, simply set one or both of 
these environment variables:

```
$ export QUANDL_CACHE_DIR=cache   # default: 'cache'
$ export QUANDL_CACHE_LIFE=120    # default: 3600 (1 hour)
$ quata get datasets/WIKI/AAPL
# => This call will be cached
```


Terminalcast
--------------------------------------------------

![Quata Demo](https://raw.githubusercontent.com/DannyBen/quata/master/demo.gif "Quata Demo")

[1]: https://www.quandl.com/blog/getting-started-with-the-quandl-api
[2]: https://github.com/DannyBen/quata/blob/master/lib/quata/docopt.txt
[3]: https://github.com/DannyBen/lightly

