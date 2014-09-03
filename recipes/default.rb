# -*- coding: utf-8 -*-
#
# Cookbook Name:: phpenv
# Recipe:: default
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

include_recipe 'apt'
include_recipe 'build-essential'

node['phpenv']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

git '/tmp/phpenv' do
  user node['phpenv']['user']
  repository node['phpenv']['repository']
  action :sync if node['phpenv']['force_update']
  action :checkout unless node['phpenv']['force_update']
end

dst_dir = node['phpenv']['root_path']
execute 'install-phpenv' do
  user node['phpenv']['user']
  cwd '/tmp/phpenv/bin'
  command "su #{node['phpenv']['user']} -c ./phpenv-install.sh"
  environment 'PHPENV_ROOT' => dst_dir if dst_dir
  not_if do
    File.exist?(dst_dir)
  end
end

plugins_dir = "#{dst_dir}/plugins"
directory plugins_dir do
  owner node['phpenv']['user']
  action :create
end

git "#{plugins_dir}/php-build" do
  user node['phpenv']['user']
  repository node['phpenv']['php-build']['repository']
  action :sync if node['phpenv']['php-build']['force_update']
  action :checkout unless node['phpenv']['php-build']['force_update']
end

template '/etc/profile.d/phpenv.sh' do
  source 'phpenv.sh.erb'
  owner 'root'
  mode '0755'
  only_if do
    node['phpenv']['create_profiled']
  end
end
