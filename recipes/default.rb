#
# Cookbook Name:: rustlang
# Recipe:: default
#
# Copyright (c) 2015 Matthew Valentine-House
#

# Rust-lang version specific variables
#
architecture = node['kernel']['machine']
version      = node['rustlang']['version']
checksum     = node['rustlang']['checksum']

rust_canonical_basename = "rust-#{version}-#{architecture}-unknown-linux-gnu"

# File blobs used for installation
#
download_file          = "https://static.rust-lang.org/dist/#{rust_canonical_basename}.tar.gz"
cached_download_object = "#{Chef::Config[:file_cache_path]}/rust.tar.gz"
rust_installation_path = "#{node['rustlang']['installation_prefix']}/#{rust_canonical_basename}"

# MAIN RECIPE
#
remote_file cached_download_object do
  source download_file
  use_last_modified false
  checksum checksum unless checksum.empty?
  not_if "rustc --version|grep #{version}"
  notifies :run, 'execute[unpack rust]', :immediately
end

file '/etc/ld.so.conf.d/usr_local.conf' do
  content '/usr/local/lib'
  notifies :run, 'execute[ldconfig]', :delayed
end

execute "unpack rust" do
  action :nothing
  command "tar zxvf #{cached_download_object}"
  cwd node['rustlang']['installation_prefix']
  notifies :run, 'execute[rust installer]', :immediately
end

execute "rust installer" do
  action :nothing
  command "sh install.sh"
  cwd rust_installation_path
  notifies :run, 'execute[ldconfig]', :delayed
end

execute 'ldconfig' do
  action :nothing
end
