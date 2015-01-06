# -*- coding: utf-8 -*-

require 'spec_helper'

%w(
  re2c
  libsqlite0-dev
  libxml2-dev
  libpcre3-dev
  libbz2-dev
  libcurl4-openssl-dev
  libdb-dev
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
  libssl-dev
  libreadline-dev
  git
).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file('/tmp/phpenv') do
  it { should be_directory }
end

describe user('phpenv') do
  it { should exist }
  it { should belong_to_group('phpenv') }
end

describe group('phpenv') do
  it { should exist }
end

%w(/home/phpenv /opt/phpenv/plugins /opt/phpenv /opt/phpenv/plugins/php-build).each do |dir_name|
  describe file(dir_name) do
    it { should be_directory }
    it { should be_owned_by 'phpenv' }
  end
end

describe file('/etc/profile.d/phpenv.sh') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode '755' }
end

describe file('/tmp/testfile') do
  it { should be_file }
  it { should be_owned_by 'phpenv' }
  it { should contain('awesome content') }
end

describe command('/opt/phpenv/bin/phpenv global') do
  its(:stdout) { should match(/5.4.0/) }
end
