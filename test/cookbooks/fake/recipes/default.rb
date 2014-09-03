# -*- coding: utf-8 -*-
phpenv_build '5.4.0'
phpenv_global '5.4.0'

cookbook_file '/tmp/awesome-script.php' do
  source 'awesome-script.php'
  mode '0775'
end

phpenv_script 'execute-php-script' do
  code '/tmp/awesome-script.php'
end
