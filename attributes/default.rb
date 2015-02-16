#
# Cookbook Name:: solr
# Attributes:: default
#
# Copyright 2013, David Radcliffe
#

default['solr']['version']  = '4.10.3'
default['solr']['url']      = "https://archive.apache.org/dist/lucene/solr/#{node['solr']['version']}/solr-#{node['solr']['version']}.tgz"
default['solr']['version_checksum'] = 'ac7024a0a759c6c53cc3a66b3a84757d599d350f491eb221160613356532e2b6'
default['solr']['data_dir'] = '/etc/solr'
default['solr']['dir']      = '/opt/solr'
default['solr']['port']     = '8984'
default['solr']['pid_file'] = '/var/run/solr.pid'
default['solr']['log_file'] = '/var/log/solr.log'
default['solr']['install_java'] = true

default['solr']['java_options'] = '-Xms128M -Xmx512M'
