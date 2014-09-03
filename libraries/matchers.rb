# -*- coding: utf-8 -*-
if defined?(ChefSpec)
  def run_phpenv_script(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:phpenv_script, :run, resource_name)
  end

  def create_phpenv_global(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:phpenv_global, :create, resource_name)
  end

  def run_phpenv_build(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:phpenv_build, :run, resource_name)
  end
end
