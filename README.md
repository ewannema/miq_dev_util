# MiqDevUtil

This is a set of helper classes to make developing in the ManageIQ automate
model less cumbersome. By putting helper code and commonly used methods in this
gem we can reduce the amount of code copied and pasted between methods.


## Installation

```
$ gem install miq_dev_util
```


## Usage

```ruby
# Pull the gem in to we can use it
require 'miq_dev_util'
```

### Logging ###

```ruby
@logger = MiqDevUtil::Logger.new($evm, 'my_method_name')
@logger.log('Hello World')

@logger.dump_root

@logger.dump_attributes($evm.root['vm'], 'root vm')
@logger.dump_associations($evm.root['vm'], 'root vm')
@logger.dump_virtual_columns($evm.root['vm'], 'root vm')

@logger.dump_info($evm.root['vm'], 'root vm') # dumps attributes,
                                              #       associations and
                                              #       virtual_columns
```

### EMS Credentials ###

```ruby
vm = $evm.root['vm']
credentials = MiqDevUtil::EMS.get_credentials(vm.ext_management_system)
vim = RbVmomi::VIM.connect credentials
```

### Automate Model ###

```ruby
automate_helper = MiqDevUtil::Automate.new($evm)

# Instantiate an automate instance at path or raise an exception with the
# message provided if the instantiation returns nil (not found).
automate_helper.instantiate_or_raise(path, message)

# This is a hacky workaround used to get an instance without executing the
# methods on it. It fails if a message is passed in the path or if the
# message field on the any of the methods are *.
automate_helper.get_instance_with_attributes(path)
```

### Generic Code ###

```ruby
# Perform a deep copy on objects that support marshalling.
MiqDevUtil::Code.deep_copy(object)
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ewannema/miq_dev_util.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

