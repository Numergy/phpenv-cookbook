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

group node['phpenv']['group'] do
  members node['phpenv']['group_users'] if node['phpenv']['group_users']
end

user node['phpenv']['user'] do
  shell '/bin/bash'
  group node['phpenv']['group']
  supports manage_home: node['phpenv']['manage_home']
  home node['phpenv']['user_home']
end

git '/tmp/phpenv' do
  user node['phpenv']['user']
  group node['phpenv']['group']
  repository node['phpenv']['git_repository']
  reference node['phpenv']['git_reference']
  action :sync if node['phpenv']['git_force_update']
  action :checkout unless node['phpenv']['git_force_update']
end

dst_dir = node['phpenv']['root_path']
directory dst_dir do
  group node['phpenv']['group']
  user node['phpenv']['user']
  recursive true
end

execute 'install-phpenv' do
  group node['phpenv']['group']
  user node['phpenv']['user']
  cwd '/tmp/phpenv/bin'
  command './phpenv-install.sh'
  environment 'PHPENV_ROOT' => dst_dir if dst_dir
  not_if do
    File.exist?(File.join(dst_dir, 'bin', 'phpenv'))
  end
end

plugins_dir = "#{dst_dir}/plugins"
directory plugins_dir do
  group node['phpenv']['group']
  owner node['phpenv']['user']
  action :create
end

git "#{plugins_dir}/php-build" do
  user node['phpenv']['user']
  group node['phpenv']['group']
  repository node['phpenv']['php-build']['git_repository']
  reference node['phpenv']['php-build']['git_reference']
  action :sync if node['phpenv']['php-build']['git_force_update']
  action :checkout unless node['phpenv']['php-build']['git_force_update']
end

template '/etc/profile.d/phpenv.sh' do
  source 'phpenv.sh.erb'
  owner 'root'
  mode '0755'
  only_if do
    node['phpenv']['create_profiled']
  end
end
