# Nasdaq Data Link API and Command Line

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
result = nasdaq.get 'datatables/WIKI/PRICES', ticker: 'NVDA' # => Hash
```

In addition, for convenience, you can use the first part of the endpoint as
a method name, like this:

```ruby
result = nasdaq.datatables 'WIKI/PRICES', ticker: 'NCDA'
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
result = nasdaq.get! 'datatables/WIKI/PRICES', ticker: 'NVDA'

# Request Object
p result.request.class
# => HTTParty::Request

# Response Object
p result.response.class
# => Net::HTTPOK

p result.response.body
# => JSON string

p result.response.code
# => 200

p result.response.msg
# => OK

# Headers Object
p result.headers
# => Hash with headers

# Parsed Response Object
p result.parsed_response
# => Hash with HTTParty parsed response 
#    (this is the content returned with #get)
```

You can get the response as CSV by calling `get_csv`:

```ruby
result = nasdaq.get_csv 'datatables/WIKI/PRICES', ticker: 'NVDA'
# => CSV string
```

To save the output directly to a file, use the `save` method:

```ruby
nasdaq.save 'filename.json', 'datatables/WIKI/PRICES', ticker: 'NVDA'
```

Or, to save CSV, use the `save_csv` method:

```ruby
nasdaq.save_csv 'filename.csv', 'datatables/WIKI/PRICES', ticker: 'NVDA'
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
$ nasdaq get datatables/WIKI/PRICES ticker:NVDA
# => This call will be cached
```

