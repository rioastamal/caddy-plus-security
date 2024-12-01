# Caddy with Security Plugin

Bash script for automating dependency installation and custom [Caddy](https://caddyserver.com/) build with [caddy-security](https://github.com/greenpau/caddy-security) plugin. Pre-built binaries can be found on the GitHub release page.

## Features

- Automatically installs Go and `xcaddy` for building Caddy.
- Supports both `x86_64` and `aarch64` architectures.
- Builds Caddy with the specified version of the caddy-security plugin.
- Generates a detailed release report for the built Caddy binary.
- Fully customizable with environment variables.

## Requirements

- Bash shell (it should work on other shells as well)
- `curl` installed.

## Installation

Download the script:

```sh
curl -sL -o build.sh 'https://raw.githubusercontent.com/rioastamal/caddy-plus-security/refs/heads/main/build.sh'
```

or clone the repository:

```sh
git clone https://github.com/rioastamal/caddy-plus-security.git
cd caddy-plus-security
```

## Usage

Run the script to build Caddy with the caddy-security plugin:

```sh
bash build.sh
```

By default, the script installs:
- **Go**: Version `1.23.3`
- **xcaddy**: Version `0.4.4`
- **Caddy**: Version `2.8.4`
- **caddy-security**: Version `1.1.29`

### Output

The built Caddy binary and release notes are saved in the `./out/` directory.

```sh
./out/caddy      # The built Caddy binary
./out/release.txt # Release notes
```

### Customization

You can customize versions and skip installation steps by setting the following environment variables:

| Environment Variable     | Description                              | Default Value  |
|--------------------------|------------------------------------------|----------------|
| `GO_VERSION`             | Version of Go to install                | `1.23.3`       |
| `XCADDY_VERSION`         | Version of `xcaddy` to install          | `0.4.4`        |
| `CADDY_VERSION`          | Version of Caddy to build               | `2.8.4`        |
| `SECURITY_VERSION`       | Version of the caddy-security plugin    | `1.1.29`       |
| `CADDY_OUTPUT`           | Output path for the built Caddy binary  | `./out/caddy`  |
| `SKIP_GO_INSTALLER`      | Skip Go installation (set to `yes`)     | `no`           |
| `SKIP_XCADDY_INSTALLER`  | Skip `xcaddy` installation (set to `yes`)| `no`           |

Example:

```sh
GO_VERSION=1.20.5 CADDY_VERSION=2.8.0 SECURITY_VERSION=1.0.0 bash build-caddy.sh
```

### Updating PATH

The installation script places Go and xcaddy in $HOME/.local. Restart your shell or update PATH to enable.

```sh
source ~/.bashrc
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE.txt) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any bug fixes or feature requests.
