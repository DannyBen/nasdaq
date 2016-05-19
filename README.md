Quata - Quandl API Library and Command Line
==================================================

---

Quata is a lightweight ruby library for accessing Quandl with a command 
line interface.

---

Features
--------------------------------------------------

* Access any Quandl endpoint directly.
* Display output in various formats.
* Save output to a file, including bulk downloads.

Example
--------------------------------------------------

First, require and initialize Quata with your API key

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
result = quandl.save "aapl.csv", "datasets/WIKI/AAPL.csv", rows: 3
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

Run `quata --help` for more information.

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