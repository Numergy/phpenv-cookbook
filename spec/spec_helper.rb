# -*- coding: utf-8 -*-

$LOAD_PATH << File.expand_path('../providers', __FILE__)
$LOAD_PATH << File.expand_path('../libraries', __FILE__)
$LOAD_PATH << File.expand_path('../resources', __FILE__)

require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/application'

ChefSpec::Coverage.start! { add_filter 'phpenv' }
RSpec.configure do |config|
  config.log_level = :error
  config.mock_with :rspec do |mocks|
    mocks.syntax = :should
  end
  config.path = File.expand_path('ohai.json', File.dirname(__FILE__))
end

# Following code is based on the chef-user repository
# Link: https://github.com/fnichol/chef-user/blob/master/test/spec_helper.rb
# Load custom resource
module ResourceMixins
  def load_resource(cookbook, lwrp)
    file_path = File.join(File.dirname(__FILE__), '../resources', "#{lwrp}.rb")
    resource = Chef::Resource::LWRPBase.build_from_file(cookbook, File.expand_path(file_path), nil)
    resource == true ? loaded_resource(cookbook, lwrp) : resource
  end

  def resource_klass(cookbook, lwrp)
    Chef::Resource.const_get(lwrp_const(cookbook, lwrp))
  end

  def lwrp_const(cookbook, lwrp)
    "#{cookbook.capitalize}#{lwrp.capitalize}"
  end

  def loaded_resource(cookbook, lwrp)
    Chef::Resource.deprecated_constants[lwrp_const(cookbook, lwrp).intern]
  end
end
