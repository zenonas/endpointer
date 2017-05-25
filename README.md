# Endpointer

[![Gem Version](https://badge.fury.io/rb/endpointer.svg)](http://badge.fury.io/rb/endpointer) [![Build Status](https://travis-ci.org/zenonas/endpointer.svg?branch=master)](https://travis-ci.org/zenonas/endpointer) [![Code Climate](https://codeclimate.com/github/zenonas/endpointer/badges/gpa.svg)](https://codeclimate.com/github/zenonas/endpointer) [![Test Coverage](https://codeclimate.com/github/zenonas/endpointer/badges/coverage.svg)](https://codeclimate.com/github/zenonas/endpointer/coverage) [![Issue Count](https://codeclimate.com/github/zenonas/endpointer/badges/issue_count.svg)](https://codeclimate.com/github/zenonas/endpointer)

Endpointer is a small gem that tries to act as a caching proxy between your dev machine and any web service. The motivation was to provide an easy to configure and use fake web service that is able to host any amount of resources, returning canned responses, that are easy to modify. Please note the gem is still in early and active development and as such some features may be missing. For a list of features that are still missing consult [the list at the end of this readme](#upcoming-features). If you would like a feature please feel free to raise an issue or a pull request. All contributions are welcome.

## Requirements

* Ruby 2.2+ (Tests running against MRI 2.4.0, 2.3.3, 2.2.6, and JRuby 9.1.6.0)

## Installation

Add this line to your Gemfile:

```ruby
gem 'endpointer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install endpointer

## Usage

In order to use Endpointer you need to create a JSON configuration file with the following format

```json
[
  {
    "id": "some_unique_identifier_for_the_resource",
    "method": "get",
    "url": "http://httpbin.org/get",
    "headers": {
      "Authorization": "Bearer test",
      "Accept": "application/json"
    },
    "matchers": {
      "matcher-id": "some regex"
    },
    "substitutions": [
      {
        "from_request": "Some regex with a named matcher called match (?<match\\w+)",
        "to_response": "Some regex with a named matcher called match (?<match\\w+)",
      },
      ...
    ],

  },
  ...
]
```

You can then invoke endpointer by executing

    $ endpointer

(Note: Endpointer by default looks for a file called `endpointer.json` in the current directory)

A full list of endpointer commands can be seen by invoking `endpointer --help`
```
❯ endpointer --help
Usage: endpointer [options]
    -d, --cache-dir CACHE_DIR        Modifies the default cache directory [Default: TMP_DIR/endpointer_cache]
    -i, --invalidate                 Invalidates the cache at startup
    -c, --config CONFIG              Override the default resource config file path. [Default: ./endpointer.json]

```

Or, include it in a config.ru

```ruby

#config.ru
require 'endpointer'

Endpointer.configure do |config|
  config.invalidate = false # Default
  config.resource_config = File.read('./endpointer.json') # Default
  config.cache_dir = File.join(Dir.tmpdir, 'endpointer_cache') # Default
end

run Endpointer.app
```

Endpointer will attempt to return a cached resource, if one is found to match the request. Otherwise, a call to the real service will be performed and the response, if successful, persisted.

A simple example request to endpointer using cURL:

    $ curl http://localhost:4567/get

If the request is to be executed against the real service the headers defined in the config will be used with their default values unless overridden. An example request overriding the Accept header follows.

    $ curl -H "Accept: text/plain" http://localhost:4567/get


### Custom matchers

Endpointer now supports custom matchers with the goal to give you more fine grained control of what gets cached. This allows you to cache different requests using a regex separately. You just define your resource with its custom matchers as shown above. Endpointer will then attempt to match the regex against the request body and store the response separately if it matches. If no matcher matches it will default to the default cache key for the resource(resource id).

### Substitutions

Endpointer can take a list of regexes to copy values from the request and replace into the response. This is particularly useful if your use case needs a cached response that needs different values based on the request.

### Caching

By default endpointer will use your operating system's temp directory to store its cache files `(TMP_DIR/endpointer_cache)`. In order to configure the cache path you need to pass the `--cache-dir=<path>` argument.

    $ endpointer -cache-dir=/path/to/cache

You can provide the `--invalidate` flag to the command line to invalidate the cache. This empties the endpointer_cache directory.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zenonas/endpointer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Upcoming features

As mentioned above I'm actively going to work on improving endpointer and the following are a few features that I would like to see implemented. Feel free to suggest new ones or work on one yourself.

* The ability to easily edit cached files. Maybe a second executable that allows you to edit the canned responses in a pretty JSON format
* A `--debug` flag to the command line that will give a pry window on every request allowing you to play with the Request and Response objects.
* Configurable port(this can already be done if using config.ru)
* Support multiple key/value stores for caching. Currently only uses local YAML files. One Suggestion is Redis support.
* Support response manipulator plugins that can pre-process responses

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
