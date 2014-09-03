# -*- coding: utf-8 -*-
#
# Cookbook Name:: phpenv
# Attributes:: default
#
# Copyright 2014, Numergy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['phpenv']['user'] = 'root'
default['phpenv']['root_path'] = '/usr/local/phpenv'
default['phpenv']['create_profiled'] = true
default['phpenv']['force_update'] = false
default['phpenv']['repository'] = 'https://github.com/CHH/phpenv.git'
default['phpenv']['php-build']['force_update'] = false
default['phpenv']['php-build']['repository'] = 'https://github.com/CHH/php-build.git'

case platform
when 'redhat', 'centos', 'fedora', 'amazon', 'scientific'
  default['phpenv']['packages'] = %w(
    git
  )
when 'debian', 'ubuntu', 'suse'
  default['phpenv']['packages'] = %w(
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
  )
when 'freebsd'
  default['phpenv']['packages'] = %w(
    git
  )
end
