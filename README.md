# phpenv Cookbook | [![Build Status](https://travis-ci.org/Numergy/phpenv-cookbook.svg?branch=master)](https://travis-ci.org/Numergy/phpenv-cookbook)

Manage installation of multiple PHP versions via [phpenv][phpenv] and [php-build][php-build]. Also provides a set of lightweight resources and providers.

If you've used [rbenv][rbenv] or [pyenv][pyenv], this is a port of that concept for PHP.

# Requirements

- `build-essential`
- `apt`


## Attributes

Default user

```ruby
default['phpenv']['user'] = 'root'
```

Default path to install phpenv

```ruby
default['phpenv']['root_path'] = '/usr/local/phpenv'
```

Create file in profile.d

```ruby
default['phpenv']['create_profiled'] = true
```

Force update phpenv git repository

```ruby
default['phpenv']['force_update'] = false
```

Git repository for phpenv

```ruby
default['phpenv']['repository'] = 'https://github.com/CHH/phpenv.git'
```

Force update php-build git repository

```ruby
default['phpenv']['php-build']['force_update'] = false
```

Git repository for php-build

```ruby
default['phpenv']['php-build']['repository'] = 'https://github.com/CHH/php-build.git'
```

Packages to install

```ruby
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
```

## Resources and providers

### phpenv_build
This resource installs a specified version of PHP.

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>:install</td>
      <td>
        Build and install a PHP version.
      </td>
      <td>Yes</td>
    </tr>
  </tbody>
</table>

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>version</td>
      <td>
        <b>Name attribute:</b> the name of a PHP version (e.g. `5.3.28`)
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated phpenv installation on which to apply an action. The default value of <code>nil</code> denotes a system-wide phpenv installation is being targeted. <b>Note:</b> if specified, the user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>root_path</td>
      <td>
        The path prefix to phpenv installation, for example:
        <code>/opt/phpenv</code>.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>environment</td>
      <td>
        A hash of environment variables to set before running this command.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### Examples

##### Install PHP 5.3.28

```ruby
phpenv_php '5.3.28' do
  action :install
end
```

```ruby
phpenv_php '5.3.28'
```

**Note:** the install action is default, so the second example is a more common usage.


### phpenv_script

This resource is a wrapper for the `script` resource which wraps the code block in an `pĥpenv`-aware environment.
See the Opscode [script resource][script_resource] documentation for more details.

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>run</td>
      <td>Run the script</td>
      <td>Yes</td>
    </tr>
  </tbody>
</table>

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>name</td>
      <td>
        <b>Name attribute:</b> Name of the command to execute.
      </td>
      <td>name</td>
    </tr>
    <tr>
      <td>phpenv_version</td>
      <td>
        A version of PHP being managed by phpenv.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>root_path</td>
      <td>
        The path prefix to phpenv installation, for example:
        <code>/opt/phpenv</code>.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>code</td>
      <td>
        Quoted script of code to execute or simply a path to a file to execute in phpenv context.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>creates</td>
      <td>
        A file this command creates - if the file exists, the command will not be run.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>cwd</td>
      <td>
        Current working directory to run the command from.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>environment</td>
      <td>
        A hash of environment variables to set before running this command.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>group</td>
      <td>
        A group or group ID that we should change to before running this command.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>path</td>
      <td>
        An array of paths to use when searching for the command.
      </td>
      <td><code>nil</code>, uses system path</td>
    </tr>
    <tr>
      <td>returns</td>
      <td>
        The return value of the command (may be an array of accepted values) this resource raises an exception if the return value(s) do not match.
      </td>
      <td><code>0</code></td>
    </tr>
    <tr>
      <td>timeout</td>
      <td>
        How many seconds to let the command run before timing out.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated phpenv installation on which to apply an action. The default value of <code>nil</code> denotes a system-wide phpenv installation is being targeted. <b>Note:</b> if specified, the user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>umask</td>
      <td>
        Umask for files created by the command.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### Examples

##### Reload cache by running command

```ruby
phpenv_script 'reload-cache' do
  phpenv_version '5.4.0'
  user           'deploy'
  group          'deploy'
  cwd            '/opt/shared
  code           './reload-cache.php'
end
```



### phpenv_global

This resource sets the global version of PHP to be used in all shells.

#### Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>create</td>
      <td>
        Sets the global version of PHP to be used in all shells.
      </td>
      <td>Yes</td>
    </tr>
  </tbody>
</table>

#### Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>phpenv_version</td>
      <td>
        <b>Name attribute:</b> a version of PHP being managed by phpenv.
        <b>Note:</b> the version of PHP must already be installed but not installed it automatically.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated phpenv installation on which to apply an action. The default value of <code>nil</code> denotes a system-wide phpenv installation is being targeted.
        <b>Note:</b> if specified, the user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>root_path</td>
      <td>
        The path prefix to phpenv installation, for example:
        <code>/opt/phpenv</code>.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### Examples

##### Set PHP 5.3.28 as global

```ruby
phpenv_global "5.3.28"
```

##### Set system php version as global

```ruby
phpenv_global 'system'
```

##### Set PHP 5.4.0 as global for a user

```ruby
phpenv_global '5.4.0' do
  user 'bamboo'
end
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors:
 - Pierre Rambaud (pierre.rambaud@numergy.com)


[script_resource]:  http://docs.opscode.com/resource_script.html
[rbenv]:            https://github.com/sstephenson/rbenv
[pyenv]:            https://github.com/yyuu/pyenv
[phpenv]:           https://github.com/CHH/phpenv
[php-build]:        https://github.com/CHH/php-build
