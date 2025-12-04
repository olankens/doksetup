# OVERVIEW

This post-installation script prepares an [Ubuntu](https://ubuntu.com/download/server) server for [Dokploy](https://dokploy.com/) by updating and configuring the system, installing required dependencies, and setting up [CrowdSec](https://www.crowdsec.net/) for security and intrusion prevention. It is ideal for cheap deployments and tailored for solo developers seeking a simple, secure, and efficient setup.

<hr>

### Script Previews

<img src=".assets/632x640.png" width="49.375%"><img src=".assets/1x1.gif" width="1.25%"><img src=".assets/632x640.png" width="49.375%">

<hr>

# GUIDANCE

### Getting Started

Blindly executing this is strongly discouraged.

```shell
curl -fsSL https://raw.githubusercontent.com/olankens/doksetup/HEAD/src/ubuntu.sh | bash
```
