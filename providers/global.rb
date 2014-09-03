# -*- coding: utf-8 -*-
#
# Cookbook Name:: phpenv
# Providers:: global
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

action :create do
  if current_global_version != new_resource.phpenv_version
    command = %(phpenv global #{new_resource.phpenv_version})

    phpenv_script "#{command} #{which_phpenv}" do
      code command
      user new_resource.user if new_resource.user
      root_path new_resource.root_path if new_resource.root_path

      action :nothing
    end.run_action(:run)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("#{new_resource} is already set - nothing to do")
  end
end
