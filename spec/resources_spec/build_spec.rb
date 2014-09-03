# -*- coding: utf-8 -*-
require_relative '../spec_helper'

describe 'Chef::Resource::PhpenvBuild' do
  include ResourceMixins

  let(:cookbook) do
    :phpenv
  end

  let(:lwrp) do
    :build
  end

  before(:each) do
    @resource = load_resource(cookbook, lwrp).new('5.4.0')
  end

  after(:each) do
    unload_resource(cookbook, lwrp)
  end

  it 'should set the name and version' do
    expect(@resource.name).to eq('5.4.0')
    expect(@resource.version).to eq('5.4.0')
  end

  { user: 'got', version: '5.5.0', root_path: '/home/got' }.each do |key, value|
    it "should takes #{key} parameter" do
      @resource.send(key, value)
      expect(@resource.send(key)).to eq(value)
    end
  end

  it 'should takes environment variables' do
    @resource.send('environment', 'USER' => 'got')
    expect(@resource.environment).to eq('USER' => 'got')
  end

  it 'should return phpenv build version' do
    expect(@resource.to_s).to eq('phpenv_build[5.4.0] (system)')
    @resource.send('user', 'got')
    expect(@resource.to_s).to eq('phpenv_build[5.4.0] (got)')
  end
end
