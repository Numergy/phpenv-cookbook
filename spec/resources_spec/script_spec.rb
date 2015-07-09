# -*- coding: utf-8 -*-
require_relative '../spec_helper'

describe 'Chef::Resource::PhpenvScript' do
  include ResourceMixins

  let(:cookbook) do
    :phpenv
  end

  let(:lwrp) do
    :script
  end

  before(:each) do
    @resource = load_resource(cookbook, lwrp).new('awesome-script')
  end

  it 'should set the name' do
    expect(@resource.name).to eq('awesome-script')
  end

  {
    user: 'got',
    group: 'got',
    cwd: '/home/got',
    creates: '/home/got/test',
    code: 'echo "here";',
    phpenv_version: '5.4.0',
    root_path: '/home/got',
    environment: { 'USER' => 'got' },
    path: ['/usr', '/usr/bin'],
    returns: [0, 1],
    timeout: 10,
    umask: '0775'
  }.each do |key, value|
    it "should takes #{key} parameter" do
      @resource.send(key, value)
      expect(@resource.send(key)).to eq(value)
    end
  end

  it 'should return phpenv script as string' do
    expect(@resource.to_s).to eq('phpenv_script[awesome-script]')
  end
end
