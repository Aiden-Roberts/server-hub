# Homelab Infrastructure as Code

## Overview

This project uses Ansible to automate baseline configuration and service management for an Ubuntu Server homelab. It demonstrates repeatable system administration, configuration management, and Infrastructure as Code practices relevant to cybersecurity and computer science.

## Objectives

- Automate baseline server configuration.
- Install essential packages and manage system services.
- Maintain standardized homelab configuration files.
- Deploy a test Docker Compose project through Ansible.
- Practice repeatable configuration management and validation.

## Technologies

- Ubuntu Server
- Ansible
- YAML
- Docker and Docker Compose
- Linux system administration

## Project Structure

```text
ansible/
├── ansible.cfg
├── inventory/
│   ├── hosts.example.yml
│   └── hosts.yml              # Local inventory; not committed
├── playbooks/
│   ├── apply_baseline.yml
│   └── system_info.yml
├── roles/
│   └── homelab_baseline/
│       ├── defaults/
│       ├── handlers/
│       └── tasks/
└── test-compose/
    └── compose.yml
```

## Automated Configuration

The `homelab_baseline` role is designed to:

- Create `/opt/homelab` and manage its metadata and configuration files.
- Install baseline utilities such as `curl`, `git`, `vim`, `htop`, and `unzip`.
- Ensure the cron and Docker services are enabled and running.
- Deploy a Docker Compose test project.

SSH authentication hardening is not currently performed by this role.

## Setup and Validation

1. Install Ansible and the dependencies required by the playbooks.
2. Review `inventory/hosts.example.yml` and create a local `inventory/hosts.yml` with the correct target host and SSH user.
3. Review `ansible.cfg` and the role defaults to understand the target paths and intended changes.
4. Run a syntax check:

   ```bash
   ansible-playbook playbooks/apply_baseline.yml --syntax-check
   ```

5. Review the playbook and target inventory before applying changes to a server.

To apply the baseline, run the following from the `ansible/` directory only after reviewing the tasks and confirming the target:

```bash
ansible-playbook playbooks/apply_baseline.yml
```

The playbook uses privilege escalation for tasks that require administrative access. Its tasks can modify the target system, so do not run it against a production system without understanding the changes.

## Validation

- Review the play recap for failed or unreachable hosts.
- Verify that managed files, packages, and services are in the expected state.
- Run the playbook again in a suitable test environment to assess repeatability.
- Validate any future security-related changes independently before deployment.

## Security Considerations

- Keep the local inventory out of version control if it contains private host details.
- Do not commit passwords, private keys, tokens, or other secrets.
- Review role defaults and target paths before executing a playbook.
- Test security-sensitive changes in a controlled environment and maintain an appropriate recovery method.

## Future Improvements

- Add automated syntax checks and testing.
- Introduce Ansible Vault for managing secrets.
- Add version-controlled configuration reviews.
- Improve deployment and rollback procedures.
- Integrate the project into a documented GitHub portfolio.

## Disclaimer

This project is intended for learning, defensive security, and personal homelab administration. Review configuration changes before applying them to a server.
