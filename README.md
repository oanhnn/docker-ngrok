# oanhnn/docker-ngrok

[![Build Status](https://github.com/oanhnn/docker-ngrok/workflows/CI/badge.svg)](https://github.com/oanhnn/docker-ngrok/actions)
[![Docker Build Status](https://img.shields.io/docker/build/oanhnn/ngrok)](https://hub.docker.com/r/oanhnn/ngrok)
[![Docker Pulls](https://img.shields.io/docker/pulls/oanhnn/ngrok)](https://hub.docker.com/r/oanhnn/ngrok)
[![Software License](https://img.shields.io/github/license/oanhnn/laravel-logzio.svg)](LICENSE)

A [Docker][docker] image for [ngrok][ngrok] v2, introspected tunnels to localhost.
The idea was originally inspired by the [wernight/ngrok][wernight/ngrok] image.

## Features

- [x] **Small**: Built using [busybox][busybox].
- [x] **Simple**: Just link as `http` or `https` in most cases, see below; exposes ngrok server `4040` port.
- [x] **Secure**: Runs as non-root user with a random UID `6737` (to avoid mapping to an existing UID).

## Usage

Supposing you've an Apache or Nginx Docker container named `web` listening on port 8080:

```shell
$ docker run --rm -it --link web oanhnn/ngrok ngrok http web:8080
```

To see command-line options, run `docker run --rm oanhnn/ngrok ngrok --help`.

## Environment variable

| Environment variable   | Note |
|------------------------|------|
| `NGROK_AUTH`           | Authentication key for your Ngrok account. This is needed for custom subdomains, custom domains, and HTTP authentication |
| `NGROK_HOSTNAME`       | Paying Ngrok customers can specify a custom domain. Only one subdomain or domain can be specified, with the domain taking priority |
| `NGROK_SUBDOMAIN`      | Name of the custom subdomain to use for your tunnel. You must also provide the authentication token |
| `NGROK_REMOTE_ADDR`    | Name of the reserved TCP address to use for a TCP tunnel. You must also provide the authentication token |
| `NGROK_USERNAME`       | Username to use for HTTP Basic authentication on the tunnel. You must also specify an authentication token |
| `NGROK_PASSWORD`       | Password to use for HTTP Basic authentication on the tunnel. You must also specify an authentication token |
| `NGROK_PROTOCOL`       | Can either be `HTTP` or `TCP`, and it defaults to `HTTP` if not specified. If set to `TCP`, Ngrok will allocate a port instead of a subdomain and proxy TCP requests directly to your application |
| `NGROK_PORT`           | Port to expose (defaults to `80` for `HTTP` protocol). If the server is non-local, the hostname can also be specified, e.g. `192.168.0.102:80` |
| `NGROK_REGION`         | Location of the ngrok tunnel server; can be `us` (United States, default), `eu` (Europe), `ap` (Asia/Pacific) or `au` (Australia) |
| `NGROK_HEADER`         |  |
| `NGROK_DEBUG`          | If specified, container will show output to `stdout` |
| `NGROK_LOOK_DOMAIN`    | This is the domain name referred to by ngrok. (default: localhost) |
| `NGROK_BINDTLS`        | Toggle tunneling only HTTP or HTTPS traffic. When `true`, Ngrok only opens the HTTPS endpoint. When `false`, Ngrok only opens the HTTP endpoint |

## Contributing

All code contributions must go through a pull request and approved by a core developer before being merged. 
This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues](https://github.com/oanhnn/docker-ngrok/issues).

## License

This project is released under the MIT License.   
Copyright © [Oanh Nguyen](https://github.com/oanhnn)   
Please see [License File](./LICENSE) for more information.


[docker]:           https://www.docker.io/
[ngrok]:            https://ngrok.com/
[ngrok-api]:        https://ngrok.com/docs#client-api
[busybox]:          https://registry.hub.docker.com/_/busybox
[wernight/ngrok]:   https://registry.hub.docker.com/u/wernight/ngrok/
