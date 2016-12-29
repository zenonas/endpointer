# Endpointer

[![Gem Version](https://badge.fury.io/rb/endpointer.svg)](http://badge.fury.io/rb/endpointer) [![Build Status](https://travis-ci.org/zenonas/endpointer.svg?branch=master)](https://travis-ci.org/zenonas/endpointer) [![Code Climate](https://codeclimate.com/github/zenonas/endpointer/badges/gpa.svg)](https://codeclimate.com/github/zenonas/endpointer) [![Test Coverage](https://codeclimate.com/github/zenonas/endpointer/badges/coverage.svg)](https://codeclimate.com/github/zenonas/endpointer/coverage) [![Issue Count](https://codeclimate.com/github/zenonas/endpointer/badges/issue_count.svg)](https://codeclimate.com/github/zenonas/endpointer)

Endpointer is a small gem that tries to act as a caching proxy between your dev machine and any web service. The motivation was to provide an easy to configure and use fake web service that is able to host host any amount of resources returning canned responses that are easy to modify. Please note the gem is still in early and active development and as such some features may be missing. For a list of features that are still missing consult the list at the end of this readme. If you would like a feature please feel free to raise an issue or a pull request. All contributions are welcome.

## Requirements

* Ruby 2.0+ (Tests running against MRI 2.4.0, 2.3.3, and JRuby 9.1.6.0)

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
    }
  },
  ...
]
```

You can then invoke endpointer by executing

    $ endpointer [--invalidate] <path_to_json_config_file>

Endpointer will attempt to return a cached resource by matching the resource requested with a cached version and if not available will call the real service.
In order to request for example the above resource from endpointer you would type:

    $ curl http://localhost:4567/get

If the request is to be executed against the real service the headers defined in the config will be used with their default values unless overridden as in the following example:

    $ curl -H "Accept: text/plain" http://localhost:4567/get

### Caching

By default endpointer will use your operating systems temp directory to store its cache files `(TMP_DIR/endpointer_cache)`. I plan on making this configurable in the future. Possibly as a parameter.

You can provide the `--invalidate` flag to the command line to invalidate the cache. This empties the endpointer_cache directory

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zenonas/endpointer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Upcoming features

As mentioned above I'm actively going to work on improving endpointer and the following are a few features that I would like to see implemented. Feel free to suggest new ones or work on one your self.

* Custom cache path
* The ability to easily edit cached files. Maybe a second executable that allows you to edit the canned responses in a pretty JSON format
* Support all HTTP verbs(currently only GET, POST are supported methods)
* A `--debug` flag to the command line that will give a pry window on every request allowing you to play with the Request and Response objects.
* The ability to run headless on a service to make this a deployable fake web service
* Make the port configurable

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

