# Changelog

## v0.3.0-dev

- Backwards incompatible changes
    - Minimum required Elixir version is now `~> 1.11`

## v0.2.0 (2022-01-29)

- Enhancements
    - IPv6 text representations are converted to lowercase hex digits to better
      match output from the `:inet` module and closer follow RFC 5952
    - Support for "iprange" fields added ([#1](https://github.com/mneudert/ecto_ip_range/pull/1))

- Backwards incompatible changes
    - Minimum required Elixir version is now `~> 1.9`

## v0.1.0 (2020-02-29)

- Initial Release
