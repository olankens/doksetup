<hr>

<div align="center">
  <img src=".assets/icon.svg" width="132">
  <h1><samp>DOKSETUP</samp></h1>
  <p>This post-installation script prepares an <a href="https://ubuntu.com/download/server">Ubuntu</a> server for <a href="https://dokploy.com/">Dokploy</a> by updating and configuring the system, installing required dependencies, and setting up <a href="https://www.crowdsec.net/">CrowdSec</a> for security and intrusion prevention. It is ideal for low-cost deployments and tailored for solo developers or any enthusiast seeking a simple, secure, and efficient setup.</p>
</div>

<hr>

### For Ubuntu

Blindly executing this is strongly discouraged.

```shell
curl -fsSL https://raw.githubusercontent.com/olankens/doksetup/HEAD/src/ubuntu.sh | bash
```

<hr>
