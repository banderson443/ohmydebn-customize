# OhMyDebn Ansible Customization

This directory contains the Ansible configuration to automate the setup of the OhMyDebn environment. It replicates the functionality of the shell scripts in the parent directory but in a more robust and idempotent way.

## Directory Structure

- `bootstrap.sh`: The entry point script. Installs Ansible and runs the playbook.
- `local.yml`: The main playbook.
- `inventory`: Defines the target host (localhost).
- `roles/`: Contains the logic for different parts of the setup.
    - `common`: System dependencies.
    - `desktop`: Wallpaper, Conky, and desktop settings.
    - `security_tools`: Pentesting tools installation (Nmap, Metasploit, etc.).

## How to Use

### Method 1: Local Execution (Recommended for Testing)

1.  Navigate to this directory:
    ```bash
    cd ansible
    ```
2.  Run the bootstrap script:
    ```bash
    ./bootstrap.sh
    ```
    You will be prompted for your sudo password.

### Method 2: Ansible Pull (Remote Execution)

If this repository is hosted on a git server (e.g., GitHub), you can use `ansible-pull` to configure a machine from scratch without cloning the repo manually first.

```bash
sudo apt update && sudo apt install -y ansible git
sudo ansible-pull -U <YOUR_REPO_URL> ansible/local.yml
```

**Note:** You must replace `<YOUR_REPO_URL>` with the actual URL of your repository.

## Customization

- **Wallpaper**: The playbook uses `../wallpaper.png` from the repository root.
- **Conky**: The playbook uses `../Conky/` from the repository root.
- **Tools**: The list of tools installed can be found in `roles/security_tools/tasks/main.yml`.
