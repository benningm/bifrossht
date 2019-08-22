# bifrossht

An auto-routing ssh proxy command.

## What is bifrossht?

`bifrossht` is a ssh `ProxyCommand` tool.

It could be used to automate the configuration of ssh hopping
in complex environments.

## How does it work?

With the use of `HostFilter` additional lookups and rules can be
applied to the hostname before connecting:

* Additional domain lookups
* Lookup with hostname prefixes

After the hostname lookup `bifrossht` will try to detect the hop
for connecting to the target server.

First it tries to match the hop based on configured filters:

* Regex on the Hostname
* Subnet matching on the ip-address

When no explicit configuration has matched it falls back to:

* Auto-probing of hops

## Installation

`bifrossht` is written in ruby(>= 2.0) and available from rubygems.org:

```
gem install bifrossht
```

## Configuration

`bifrossht` must be configured in `~/.bifrossht.yml`:

```yaml
---
host_filters:
  - type: SearchDomain
    domains:
      - cluster-xy.provider.tld
      - internal.provider.tld
    prefixes:
      - vm00

connections:
  - name: direct
    type: Exec
    match_addr:
      - "192.168.0.0/24"
      - "192.168.1.0/24"
    parameters:
      timeout: 1
      command: nc %h %p

  - name: dmz
    type: Exec
    match:
      - "dmz.provider.tld$"
    match_addr:
      - "80.241.212.0/24"
    parameters:
      timeout: 3
      command: ssh -W hop-dmz.internal.provider.tld

  - name: internet
    type: Exec
    skip_probe: true
    match:
      - "your-server.de$"
      - "contabo.net$"
      - "compute.amazonaws.com$"
      - "google.internal$"
    parameters:
      timeout: 5
      command: proxytunnel -p gateway.internal.provider.tld:3128 -d %h:%p
```

Then configure the `ProxyCommand` in `~/.ssh/config`:

```
Host *
  ProxyCommand bifrossht connect -p %p %h
```

## Troubleshooting

Run the `bifrossht` command standalone and increase log level:

```
bifrossht -l debug connect host0815.internal.provider.tld
```

## Copyright

2019 Markus Benning

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

