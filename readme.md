## 🖥️ XRDP + Budgie Desktop in Docker (with Systemd Support)

This Docker image provides a fully functional **Budgie Desktop Environment** accessible via **Remote Desktop Protocol (RDP)**, all containerized with **Systemd** support. It's perfect for testing, remote desktop access, or developing GUI-based applications in a secure, isolated sandbox.

---

## 🚀 Features

- 🧠 **Budgie Desktop**: A modern, GNOME-based user interface
- 🔒 **Systemd in Docker**: Enables support for session-managed applications
- 📡 **XRDP Server**: Remote desktop access via port `3389`
- 🐧 **Base Image**: Built on `ubuntu:latest`

---

## 🧰 Included Packages

| Package            | Description                  |
| ------------------ | ---------------------------- |
| `wget`, `curl`     | File downloading tools       |
| `git`              | Version control              |
| `jq`               | JSON processing              |
| `zsh`              | Z Shell                      |
| `iputils-ping`     | Network diagnostics          |
| `aria2`            | Lightweight download utility |
| `xorgxrdp`, `xrdp` | XRDP server and dependencies |
| `budgie-desktop`   | Budgie desktop environment   |

---

## 🛠️ Usage

### 🔧 Build the Image

```sh
docker build -t docker-desktop .
```

### 🧪 Run the Container

⚠️ **Note**: Must be run in `--privileged` mode for Systemd to function properly.

```sh
docker run -it --rm --privileged -p 3389:3389 docker-desktop [username] [password] [yes]
```

Tip: Replace [username] and [password] with your preferred credentials. The yes argument add your accounts to sudoers group.

### 🖥️ Accessing the Desktop

Use any RDP client (e.g. Windows Remote Desktop, Remmina):
• Host: localhost (or Docker host IP)
• Port: `3389`
• Username: username
• Password: password

## 📂 File Structure

| File            | Purpose                                  |
| --------------- | ---------------------------------------- |
| `Dockerfile`    | Installs Systemd, Budgie, and XRDP       |
| `entrypoint.sh` | Initializes Systemd and custom services  |
| `start-xrdp.sh` | Configures user accounts and starts XRDP |

## 📖 License

MIT
