node['rustlang']['packages'].each do |package|
  execute "cargo install #{package}" do
    not_if "cargo install --list|grep #{package}"
  end
end
