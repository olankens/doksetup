<div align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset=".assets/icon-dark.svg">
        <img src=".assets/icon.svg" height="132">
    </picture>
    <h1><samp>DOKSETUP</samp></h1>
    <p>This post-installation script prepares an <a href="https://ubuntu.com/download/server">Ubuntu</a> server for <a href="https://dokploy.com/">Dokploy</a> by updating and configuring the system, installing required dependencies, and setting up <a href="https://www.crowdsec.net/">CrowdSec</a> for security and intrusion prevention. It is ideal for cheap deployments and tailored for solo developers or any enthusiast seeking a simple, secure, and efficient setup.</p>
</div>

---

<h3 align="center">Some Previews</h3>

<picture><source media="(prefers-color-scheme: dark)" srcset=".assets/632x640-dark.svg"><img src=".assets/632x640.svg" width="49.375%"></picture><img src=".assets/1x1.gif" width="1.25%"/><picture><source media="(prefers-color-scheme: dark)" srcset=".assets/632x640-dark.svg"><img src=".assets/632x640.svg" width="49.375%"></picture>

---

<h3 align="center">For Almalinux</h3>

<p align="center">Blindly executing this is strongly discouraged.</p>

```shell
...
```

---

<h3 align="center">For Ubuntu</h3>

<p align="center">Blindly executing this is strongly discouraged.</p>

```shell
curl -fsSL https://raw.githubusercontent.com/olankens/doksetup/HEAD/src/ubuntu.sh | bash
```