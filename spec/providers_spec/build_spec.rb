# -*- coding: utf-8 -*-
require_relative '../spec_helper'

describe 'Chef::Provider::PhpenvBuild' do
  include ResourceMixins

  let(:cookbook) do
    :phpenv
  end

  let(:lwrp) do
    :build
  end

  before do
    @runner = ChefSpec::ServerRunner.new do |node|
      node.set['phpenv']['root_path'] = '/home/got/.phpenv'
    end.converge('phpenv')
  end

  before(:each) do
    @resource = load_resource(cookbook, lwrp).new('5.5.0')
    @resource.run_context = @runner.run_context
    @provider = Chef::Platform.provider_for_resource(@resource, :build)
  end

  it 'should run phpenv build without parameter' do
    expect(@provider.action_run).to be_truthy
    expect(@runner).to run_phpenv_script('phpenv install 5.5.0 (system)').with(
      code: 'phpenv install 5.5.0',
      user: nil,
      root_path: nil,
      environment: nil
    )
  end

  it 'should run phpenv build with parameters' do
    @resource.send('root_path', '/home/got')
    @resource.send('user', 'got')
    @resource.send('environment', 'TEST' => 'something')
    expect(@provider.action_run).to be_truthy
    expect(@runner).to run_phpenv_script('phpenv install 5.5.0 (got)').with(
      code: 'phpenv install 5.5.0',
      user: 'got',
      root_path: '/home/got',
      environment: { 'TEST' => 'something' }
    )
  end
end
