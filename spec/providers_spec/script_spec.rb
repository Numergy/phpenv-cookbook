# -*- coding: utf-8 -*-
require_relative '../spec_helper'

describe 'Chef::Provider::PhpenvScript' do
  include ResourceMixins

  let(:cookbook) do
    :phpenv
  end

  let(:lwrp) do
    :script
  end

  before do
    @runner = ChefSpec::Runner.new do |node|
      node.set['phpenv']['root_path'] = '/home/got/.phpenv'
    end.converge('phpenv')
  end

  before(:each) do
    @resource = load_resource(cookbook, lwrp).new('execute-script')
    @resource.run_context = @runner.run_context
    @provider = Chef::Platform.provider_for_resource(@resource, :script)
  end

  after(:each) do
    unload_resource(cookbook, lwrp)
  end

  it 'should run phpenv script without parameter' do
    expect(@provider.action_run).to be_truthy
    expect(@runner).to run_script('execute-script').with(
      interpreter: 'bash',
      code: "export PHPENV_ROOT=\"/home/got/.phpenv\"\nexport PATH=\"${PHPENV_ROOT}/bin:$PATH\"\neval \"$(phpenv init -)\"\n",
      user: nil,
      root_path: nil,
      creates: nil,
      cwd: nil,
      group: nil,
      path: nil,
      returns: [0],
      timeout: nil,
      environment: { 'PHPENV_ROOT' => '/home/got/.phpenv' }
    )
  end

  it 'should run phpenv script with parameters' do
    CustomDir = Struct.new(:dir)
    Etc.should_receive(:getpwnam).with('got').and_return(CustomDir.new('/home/got'))
    @resource.send('root_path', '/home/got')
    @resource.send('user', 'got')
    @resource.send('returns', [0, 1])
    @resource.send('creates', '/tmp/lockfile')
    @resource.send('cwd', '/etc')
    @resource.send('group', 'got')
    @resource.send('path', ['/usr', '/usr/bin'])
    @resource.send('timeout', 10)
    @resource.send('phpenv_version', '5.5.0')
    @resource.send('environment', 'TEST' => 'something')
    @resource.send('code', './my-awesome-script.php')
    expect(@provider.action_run).to be_truthy
    expect(@runner).to run_script('execute-script').with(
      code: "export PHPENV_ROOT=\"/home/got\"\nexport PATH=\"${PHPENV_ROOT}/bin:$PATH\"\neval \"$(phpenv init -)\"\nexport PHPENV_VERSION=\"5.5.0\"\n./my-awesome-script.php",
      user: 'got',
      creates: '/tmp/lockfile',
      cwd: '/etc',
      group: 'got',
      path: ['/usr', '/usr/bin'],
      returns: [0, 1],
      timeout: 10,
      environment: { 'PHPENV_ROOT' => '/home/got', 'USER' => 'got', 'HOME' => '/home/got', 'TEST' => 'something' }
    )
  end
end
