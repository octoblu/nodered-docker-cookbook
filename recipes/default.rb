#
# Cookbook Name:: nodered-docker
# Recipe:: default
#
# Copyright (C) 2014 Jade Meskill
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'deploy'

if node["opsworks"]["instance"]["layers"].include?("docker")
  node[:deploy].each do |application, deploy|
    if deploy[:application_type] != 'other'
      Chef::Log.debug("Skipping nodered-docker for application #{application} as it is not a docker instance")
      next
    end

    opsworks_deploy_dir do
      user deploy[:user]
      group deploy[:group]
      path deploy[:deploy_to]
    end

    opsworks_deploy do
      deploy_data deploy
      app application
    end

    ruby_block "docker build #{deploy[:deploy_to]}" do
      block do
        Chef::Log.info("built docker via: #{deploy[:deploy_to]}")
        $? == 0
      end
    end
  end
end
