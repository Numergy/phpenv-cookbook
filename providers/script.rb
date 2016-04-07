# -*- coding: utf-8 -*-
#
# Cookbook Name:: phpenv
# Providers:: script
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

use_inline_resources

include Chef::Phpenv::Mixin

action :run do
  script_code = build_script_code
  script_environment = build_script_environment

  script new_resource.name do
    interpreter 'bash'
    code script_code
    user new_resource.user if new_resource.user
    creates new_resource.creates if new_resource.creates
    cwd new_resource.cwd if new_resource.cwd
    group new_resource.group if new_resource.group
    path new_resource.path if new_resource.path
    returns new_resource.returns if new_resource.returns
    timeout new_resource.timeout if new_resource.timeout
    environment script_environment
    action :nothing
  end.run_action(:run)

  new_resource.updated_by_last_action(true)
end
