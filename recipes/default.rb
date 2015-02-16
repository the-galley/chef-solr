#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2013, David Radcliffe
#

include_recipe 'ark'
include_recipe 'java' if node['solr']['install_java']

src_filename = ::File.basename(node['solr']['url'])

ark_prefix_root = # {Chef::Config['file_cache_path']}/#{src_filename}" || node.ark[:prefix_root]
ark_prefix_home = node['solr']['dir'] || node.ark[:prefix_home]

ark 'solr' do
  action :install
  url node['solr']['url']
  prefix_root ark_prefix_root
  prefix_home ark_prefix_home
  checksum node['solr']['url']
end

directory node['solr']['data_dir'] do
  owner 'root'
  group 'root'
  recursive true
  action :create
end

template '/var/lib/solr.start' do
  source 'solr.start.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    solr_dir: extract_path,
    solr_home: node['solr']['data_dir'],
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
    solr_dir: extract_path,
    solr_home: node['solr']['data_dir'],
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
