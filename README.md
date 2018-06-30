# Deadpull

A simple gem to organize storing and retrieving configuration files on AWS S3 in a programmatic, automated fashion.

Use cases:

* Automatically synchronizing newest configs during a deploy
* Bootstrapping developers' environments as part of an onboarding process
* Personal dotfiles synchronization between machines

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deadpull', '~> 0.1'
```

And then execute:

    $ bundle

If you wish to take advantage of the `deadpull` command in your project's directory, install binstubs with

    $ bundle binstubs deadpull

If you wish to use the provided `deadpull` command globally from the command line, install it with `gem`:

    $ gem install deadpull

## Configuration

Configuration uses two keys currently:

* `path` - required. This is composed of a bucket part and then a prefix, e.g. `my-fancy-bucket/a-directory/prefix`. It relates to locations on AWS S3.
* `aws` - optional. This is a hash containing anything [`Aws::S3::Client`](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html) accepts in its initializer. You should set at least `profile` and `region` keys here.

### Configuration file order

Deadpull will first look for a file called `.deadpull.yml`. Then, data from file `.deadpull.local.yml` will be merged into this. The idea is that you use `.deadpull.yml` for your public configuration and commit this file, while the local file contains e.g. secrets and does not get commited.

When using programmatic operation, any hash passed to `Deadpull::Configuration#new` will be merged into the hash resulting from the above operations, effectively giving it highest priority.

### Environment

Environment is decided by either passing it explicitly to commands, or by using `DEADPULL_ENV` or `RAILS_ENV`. If none of the above is provided, it defaults to `development`, following Rails convention.

## CLI usage

Pulling config for 'production' environment to 'tmp' example:

```
$ deadpull -e production tmp
```

Pushing config from 'tmp' to a specific path on S3 for 'staging' environment example:

```
$ deadpull -u -e staging -p my-fancy-bucket/this-project tmp
```

Note that when not given `-u` (or `--upload`), Deadpull defaults to pulling in order to prevent inadvertent damage to your configuration source-of-truth on S3.

Options description (use `-h` locally to get this):

```
Usage: deadpull [options] <path>

Options:
    -u, --upload                     Push to S3 from given path
    -e, --environment [ENVIRONMENT]  Provides environment, superseding DEADPULL_ENV and RAILS_ENV
    -p, --path [PATH]                S3 path to be used for upload or download in form of bucket-name/prefix. Supersedes config.
```

## Programmatic usage

### `Deadpull::Commands::Push`

The most complete example of local usage would be:

```ruby
configuration = Deadpull::Configuration.new({ path: ..., aws: ...}).call.value!
environment = Deadpull::Values::Environment.concretize('test')

Deadpull::Commands::Push.call('/some/local/path', configuration, environment) #=> true
# or
Deadpull::Commands::Push.call('/some/local/path/file.yml', configuration, environment) #=> true
```

Note that configuration and environment can be ommited if you want to use the defaults found by methods described in the Configuration section above.

### `Deadpull::Commands::Pull`

The most complete example of local usage would be:

```ruby
configuration = Deadpull::Configuration.new({ path: ..., aws: ...}).call.value!
environment = Deadpull::Values::Environment.concretize('test')

Deadpull::Commands::Pull.call('/some/local/path', configuration, environment) #=> true
```

Note that configuration and environment can be ommited if you want to use the defaults found by methods described in the Configuration section above.

Note that `Pull` will raise an `ArgumentError` if it detects that the given `path` is a regular file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paweljw/deadpull. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Contributors

* [@macbury](https://github.com/macbury) - collaboration on the initial idea

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Deadpull project’s codebases and issue trackers is expected to follow the [code of conduct](https://github.com/paweljw/deadpull/blob/master/CODE_OF_CONDUCT.md).
