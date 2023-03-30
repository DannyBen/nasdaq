# Testing

Run tests with:

    $ bundle exec run spec

To run a single spec file only, run something like:

    $ bundle exec run spec api

To ensure tests are running smoothly, you should set your API key in
an environment variable before running:

    $ export NASDAQ_KEY=your_key_here
    $ bundle exec run spec
