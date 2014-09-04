# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'phpenv::default' do
  describe 'with default configuration' do
    subject { ChefSpec::Runner.new.converge(described_recipe) }

    it 'should includes recipes' do
      expect(subject).to include_recipe('apt')
    end

    it 'should install packages' do
      %w(
        re2c
        libsqlite0-dev
        libxml2-dev
        libpcre3-dev
        libbz2-dev
        libcurl4-openssl-dev
        libdb4.8-dev
        libjpeg-dev
        libpng12-dev
        libxpm-dev
        libfreetype6-dev
        libmysqlclient-dev
        postgresql-server-dev-all
        libt1-dev
        libgd2-xpm-dev
        libgmp-dev
        libsasl2-dev
        libmhash-dev
        unixodbc-dev
        freetds-dev
        libpspell-dev
        libsnmp-dev
        libtidy-dev
        libxslt1-dev
        libmcrypt-dev
        git
      ).each do |pkg|
        expect(subject).to install_package(pkg)
      end
    end

    it 'should clone phpenv' do
      expect(subject).to checkout_git('/tmp/phpenv').with(
        repository: 'https://github.com/CHH/phpenv.git',
        reference: 'master',
        user: 'phpenv'
      )
    end

    it 'should create user' do
      expect(subject).to create_user('phpenv').with(
        group: 'phpenv',
        shell: '/bin/bash',
        supports: { manage_home: true },
        home: '/home/phpenv'
      )
    end

    it 'should create group' do
      expect(subject).to create_group('phpenv').with(
        members: []
      )
    end

    it 'should install phpenv' do
      expect(subject).to run_execute('install-phpenv').with(
        cwd: '/tmp/phpenv/bin',
        command: './phpenv-install.sh',
        user: 'phpenv'
      )

      expect(subject).to create_directory('/opt/phpenv').with(
        owner: 'phpenv',
        group: 'phpenv',
        recursive: true
      )

      expect(subject).to create_directory('/opt/phpenv/plugins').with(
        owner: 'phpenv'
      )
    end

    it 'should clone phpenv' do
      expect(subject).to checkout_git('/opt/phpenv/plugins/php-build').with(
        repository: 'https://github.com/CHH/php-build.git',
        reference: 'master',
        user: 'phpenv'
      )
    end

    it 'should create profile.d file' do
      expect(subject).to create_template('/etc/profile.d/phpenv.sh').with(
        source: 'phpenv.sh.erb',
        owner: 'root',
        mode: '0755'
      )
    end
  end

  describe 'with override configuration' do
    let(:subject) do
      ChefSpec::Runner.new do |node|
        node.set['phpenv']['root_path'] = '/home/got/.phpenv'
        node.set['phpenv']['group_users'] = ['vagrant']
        node.set['phpenv']['user'] = 'got'
        node.set['phpenv']['user_home'] = '/home/got'
        node.set['phpenv']['manage_home'] = false
        node.set['phpenv']['group'] = 'got'
        node.set['phpenv']['git_force_update'] = true
        node.set['phpenv']['git_reference'] = 'dev'
        node.set['phpenv']['php-build']['git_force_update'] = true
        node.set['phpenv']['create_profiled'] = false
        node.set['phpenv']['php-build']['git_reference'] = 'dev'
      end.converge(described_recipe)
    end

    it 'should clone phpenv' do
      expect(subject).to sync_git('/tmp/phpenv').with(
        repository: 'https://github.com/CHH/phpenv.git',
        reference: 'dev',
        user: 'got',
        group: 'got'
      )
    end

    it 'should create group' do
      expect(subject).to create_group('got').with(
        members: ['vagrant']
      )
    end

    it 'should create user' do
      expect(subject).to create_user('got').with(
        group: 'got',
        shell: '/bin/bash',
        supports: { manage_home: false },
        home: '/home/got'
      )
    end

    it 'should install phpenv' do
      expect(subject).to run_execute('install-phpenv').with(
        cwd: '/tmp/phpenv/bin',
        command: './phpenv-install.sh',
        user: 'got',
        group: 'got'
      )

      expect(subject).to create_directory('/home/got/.phpenv').with(
        owner: 'got',
        group: 'got',
        recursive: true
      )

      expect(subject).to create_directory('/home/got/.phpenv/plugins').with(
        owner: 'got',
        group: 'got'
      )
    end

    it 'should clone phpenv' do
      expect(subject).to sync_git('/home/got/.phpenv/plugins/php-build').with(
        repository: 'https://github.com/CHH/php-build.git',
        reference: 'dev',
        user: 'got',
        group: 'got'
      )
    end

    it 'should create profile.d file' do
      expect(subject).to_not create_template('/etc/profile.d/phpenv.sh')
    end
  end
end
