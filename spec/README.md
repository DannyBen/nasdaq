# Testing

Run tests with:

    $ bundle exec run spec

To run a single spec file only, run something like:

    $ bundle exec run spec api

To ensure tests are running smoothly, you should set your quandl key in
an environment variable before running:

    $ export QUANDL_KEY=your_key_here
    $ bundle exec run spec

Optionally, if you have a premium subscription, you can enable tests that
only run with a premium database by setting QUANDL_PREMIUM to the name of the
premium database you are subscribed to:

    $ export QUANDL_KEY=your_key_here
    $ export QUANDL_PREMIUM=EOD
    $ bundle exec run spec

