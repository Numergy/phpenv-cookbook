# -*- coding: utf-8 -*-

require 'serverspec'

set :backend, :exec
set :path, '$PATH:/sbin:/usr/sbin:/usr/bin:/bin'

RSpec.configure do |c|
  c.add_formatter 'RspecJunitFormatter', '/tmp/kitchen.xml'
end
