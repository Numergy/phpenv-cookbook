name 'phpenv'
maintainer 'Numergy'
maintainer_email 'pierre.rambaud@numergy.com'
license 'Apache 2.0'
description 'Installs/Configures phpenv'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.7.1'

depends 'apt'
depends 'build-essential'

%w( debian ubuntu ).each do |os|
  supports os
end

source_url 'https://github.com/Numergy/phpenv-cookbook' if
  respond_to?(:source_url)
issues_url 'https://github.com/Numergy/phpenv-cookbook/issues' if
  respond_to?(:issues_url)
