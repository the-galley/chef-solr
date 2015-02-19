#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2013, David Radcliffe
#

include_recipe 'apt::default'
include_recipe 'ark'
include_recipe 'java' if node['solr']['install_java']

ark_prefix_root = node['solr']['dir']
ark_prefix_home = node['solr']['dir']

ark 'solr' do
  url node['solr']['url']
  checksum node['solr']['version_checksum']
  owner 'root'
  version node['solr']['version']
  prefix_root ark_prefix_root unless ark_prefix_root.nil?
  prefix_home ark_prefix_home unless ark_prefix_home.nil?
end

template '/var/lib/solr.start' do
  source 'solr.start.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    solr_dir: "#{node['solr']['dir']}/solr",
    solr_home: "#{node['solr']['data_dir']}/solr",
    port: node['solr']['port'],
    pid_file: node['solr']['pid_file'],
    log_file: node['solr']['log_file'],
    java_options: node['solr']['java_options']
  )
  only_if { !platform_family?('debian') }
end

template '/etc/init.d/solr' do
  source platform_family?('debian') ? 'initd.debian.erb' : 'initd.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    solr_dir: "#{node['solr']['dir']}/solr",
    solr_home: "#{node['solr']['data_dir']}/solr",
    port: node['solr']['port'],
    pid_file: node['solr']['pid_file'],
    log_file: node['solr']['log_file'],
    java_options: node['solr']['java_options']
  )
end

service 'solr' do
  supports restart: true, status: true
  action [:enable, :start]
end
