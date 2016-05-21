Quata - Quandl API Library and Command Line
==================================================

[![Gem](https://img.shields.io/gem/v/quata.svg?style=flat-square)](https://rubygems.org/gems/quata)
[![Travis](https://img.shields.io/travis/DannyBen/quata.svg?style=flat-square)](https://travis-ci.org/DannyBen/quata)
[![Code Climate](https://img.shields.io/codeclimate/github/DannyBen/quata.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/quata)
[![Gemnasium](https://img.shields.io/gemnasium/DannyBen/quata.svg?style=flat-square)](https://gemnasium.com/DannyBen/quata)

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

Usage
--------------------------------------------------

First, require and initialize with your API key

```ruby
require 'quata'
quandl = Quandl.new 'Your API Key'
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

By default, you will get a ruby hash in return. If you wish to get the raw
output, you can use the `get!` method:

```ruby
result = quandl.get! "datasets/WIKI/AAPL", rows: 3 # => JSON string
result = quandl.get! "datasets/WIKI/AAPL.json", rows: 3 # => JSON string
result = quandl.get! "datasets/WIKI/AAPL.csv", rows: 3 # => CSV string
```

To save the output directly to a file, use the `save` method:

```ruby
quandl.save "aapl.csv", "datasets/WIKI/AAPL.csv", rows: 3
```

Debugging your request and adding "sticky" query parameters that stay with
you for the following requests is also easy:

```ruby
quandl.debug = true
quandl.param rows: 10, order: 'asc'
puts quandl.get 'WIKI/AAPL'
# => https://www.quandl.com/api/v3/WIKI/AAPL.json?auth_token=key&rows=10&order=asc

quandl.param order: nil # remove param
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

Quata uses the [WebCache][3] gem for automatic HTTP caching.
By default, all requests are cached for 60 minutes in the `./cache`
directory.

You can access the `WebCache` object through `quandle.cache`, so you 
can disable it, change its directory, or change its lifetime.

```ruby
quandl = Quandl.new 'Your API Key'
quandl.cache.disable             # Skip caching altogether
quandl.cache.dir = 'tmp/cache'   # Change cache folder
quandl.cache.life = 120          # Change cache life to 2 minutes
quandl.cache.enable              # Enable caching
```

![Quata Demo](https://raw.githubusercontent.com/DannyBen/quata/master/demo.gif "Quata Demo")

[1]: https://www.quandl.com/blog/getting-started-with-the-quandl-api
[2]: https://github.com/DannyBen/quata/blob/master/lib/quata/docopt.txt
[3]: https://github.com/DannyBen/webcache
