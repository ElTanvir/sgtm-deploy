# Installation Guide

## Quick Start

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/ElTanvir/sgtm-deploy.git
    cd sgtm-deploy
    ```

2.  **Run the Installer**:
    ```bash
    chmod +x install.sh
    sudo ./install.sh
    ```
2.1  **Pull The Image**:
    ```bash
    docker pull eltanvir/gtm-server-side:latest
    ```

3.  **Follow Prompts**:
    - The script will ask for an **Admin Username** and **Password**.
    - It will generate a self-signed SSL certificate automatically.

4.  **Access the Panel**:
    - Open your browser and navigate to `https://YOUR_SERVER_IP`.
    - Accept the security warning (due to self-signed certificate).

## Troubleshooting

### Services not starting?
Check the logs:
```bash
docker compose logs -f
```

### Port Conflicts?
Ensure ports 80 and 443 are free. Use `netstat -tulpn` to check.

### Reset Password?
Modify the environment variables in `docker-compose.yml` or restart the installer.
```bash
docker compose down
sudo ./install.sh
```
