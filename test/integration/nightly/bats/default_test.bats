@test "rustc should be installed" {
    which rustc
}

@test "rustdoc should be installed" {
    which rustdoc
}

@test "rust version should be nightly" {
    rustc --version | grep nightly
}
