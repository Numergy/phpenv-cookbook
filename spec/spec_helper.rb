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
  config.version = '16.04'
  config.platform = 'ubuntu'
  config.mock_with :rspec do |mocks|
    mocks.syntax = :should
  end
end
