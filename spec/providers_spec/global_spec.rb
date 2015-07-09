# -*- coding: utf-8 -*-
require_relative '../spec_helper'

describe 'Chef::Provider::PhpenvGlobal' do
  include ResourceMixins

  let(:cookbook) do
    :phpenv
  end

  let(:lwrp) do
    :global
  end

  before do
    @runner = ChefSpec::ServerRunner.new do |node|
      node.set['phpenv']['root_path'] = '/home/got/.phpenv'
    end.converge('phpenv')
  end

  before(:each) do
    @resource = load_resource(cookbook, lwrp).new('5.4.0')
    @resource.run_context = @runner.run_context
    @provider = Chef::Platform.provider_for_resource(@resource, :global)
  end

  it 'should run phpenv script without parameter' do
    expect(@provider.action_create).to be_truthy
    expect(@runner).to run_phpenv_script('phpenv global 5.4.0 (system)').with(
      code: 'phpenv global 5.4.0',
      user: nil,
      root_path: nil
    )
  end

  it 'should run phpenv script with parameters' do
    @resource.send('root_path', '/home/got')
    @resource.send('user', 'got')
    expect(@provider.action_create).to be_truthy
    expect(@runner).to run_phpenv_script('phpenv global 5.4.0 (got)').with(
      code: 'phpenv global 5.4.0',
      user: 'got',
      root_path: '/home/got'
    )
  end
end
