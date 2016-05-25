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
@logger.log(:info, 'Hello World')

# There are also shortcuts for different log levels.
@logger.info('Hello info')
@logger.warn('Uh oh')
@logger.error('Something went really wrong.')

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


# Condense multiple types of VM lookups into one call. This is useful when
# making an Automate method generic enough to be used during provisioning,
# with a custom button, or as a catalog item.
#
# Lookup methods used and their order can be overridden by specifying
# :lookup_order. The default is [:rootvm, :dialog_id, :provision]
#
#   * :rootvm    = $evm.root['vm']
#   * :dialog_id = look up the VM in vmdb using the VMDB ID from a dialog
#   * :provision = $evm.root['miq_provision'].vm
#
#
# The dialog name that may hold the miq ID is specified via :dialog_name
#

vm = automate_helper.resolve_vm
vm = automate_helper.resolve_vm(lookup_order: [:dialog_id],
                                dialog_name: 'dialog_vm_id')
```

Issuing automate requests within Automate.

```ruby
# Options that are used in the various methods below.
options = {}
options[:namespace] = 'MyCustomCode'
options[:class_name] = 'Methods'
options[:instance_name] = 'do_something'
options[:user_id] = $evm.vmdb(:user).find_by_userid('admin').id

ah = MiqDevUtil::Automate.new($evm)

# This uses an existing version of $evm.execute(create_automation_request) if it
# already exists (MIQ 5.5+), otherwise it backports a version to use.

request = ah.create_automation_request(options)
# or to specify user and approval
request = ah.create_automation_request(options, userid = 'admin', auto_approve = true))

#
# To run the automate request in the same zone as the VM.
#
ah.zone_aware_vm_automation_request(vm, options)

# or to specify user and approval
request = ah.zone_aware_vm_automation(vm, options, userid = 'admin', auto_approve = true))


#
# To synchronously wait for an automate request to finish.
#
updated_request = ah.wait_for_automation_request(request)

# Optional parameters
# Wait at most max_wait seconds.
# Check the status ever poll_interval seconds.
updated_request = ah.wait_for_automation_request(request, max_wait: 600,
                                                          poll_interval: 5)
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

