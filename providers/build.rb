# -*- coding: utf-8 -*-
#
# Cookbook Name:: phpenv
# Providers:: build
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

include Chef::Phpenv::Mixin

action :run do
  perform_install
  new_resource.updated_by_last_action(true)
end

private

def perform_install
  if php_installed?
    Chef::Log.debug("#{new_resource} is already installed - nothing to do")
  else
    install_start = Time.now
    Chef::Log.info("Building #{new_resource}, this could take a while...")
    execute_script
    Chef::Log.debug("#{new_resource} build time was " \
      "#{(Time.now - install_start) / 60.0} minutes")
  end
end

def php_installed?
  ::File.directory?(::File.join(phpenv_root, 'versions', new_resource.version))
end

def execute_script
  command = %(phpenv install #{new_resource.version})
  phpenv_script "#{command} #{which_phpenv}" do
    code command
    user new_resource.user if new_resource.user
    root_path new_resource.root_path if new_resource.root_path
    environment new_resource.environment if new_resource.environment
    action :nothing
  end.run_action(:run)
end
