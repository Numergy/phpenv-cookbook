# -*- coding: utf-8 -*-
#
# Cookbook Name:: phpenv
# Libraries:: Mixin
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
class Chef
  module Phpenv
    # Phpenv mixin functions
    module Mixin
      def phpenv_root
        if new_resource.root_path
          new_resource.root_path
        elsif new_resource.user
          ::File.join(user_home, '.phpenv')
        else
          node['phpenv']['root_path']
        end
      end

      def user_home
        return nil unless new_resource.user
        Etc.getpwnam(new_resource.user).dir
      end

      def which_phpenv
        "(#{new_resource.user || 'system'})"
      end

      def current_global_version
        version_file = ::File.join(phpenv_root, 'version')
        ::File.exist?(version_file) && ::IO.read(version_file).chomp
      end

      def wrap_shim_cmd(cmd)
        [%(export PHPENV_ROOT="#{phpenv_root}"),
         %(export PATH="$PHPENV_ROOT/bin:$PHPENV_ROOT/shims:$PATH"),
         %(export PHPENV_VERSION="#{new_resource.phpenv_version}"),
         %($PHPENV_ROOT/shims/#{cmd})
        ].join(' && ')
      end
    end
  end
end
