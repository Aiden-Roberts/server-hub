# Ubuntu Homelab | Cybersecurity & Infrastructure Automation

A self-managed Ubuntu Server homelab focused on defensive security, infrastructure automation, centralized logging, monitoring, and reproducible system administration.

This project is an ongoing practical learning environment for exploring Linux administration, security monitoring, Infrastructure as Code, and containerized services.

## Project Goals

- Apply defensive security principles to a self-managed Linux server.
- Centralize system and firewall logs for investigation.
- Monitor server health and container performance.
- Automate baseline configuration with Ansible.
- Develop reliable backup and recovery practices.
- Document technical decisions, validation procedures, and future improvements.

## Technology Stack

| Area | Technologies |
|---|---|
| Operating system | Ubuntu Server, Linux |
| Containers | Docker, Docker Compose |
| DNS and network services | Pi-hole |
| Metrics and monitoring | Prometheus, Grafana, Node Exporter, cAdvisor |
| Log collection and storage | Grafana Alloy, Loki |
| Infrastructure as Code | Ansible, YAML |
| Backup automation | Bash, GNU tar |
| Scripting and validation | Bash, Python, Git |

## Architecture Overview

The homelab uses Docker Compose to manage services on an Ubuntu Server host.

- **Pi-hole** provides network-level DNS filtering.
- **Prometheus** collects metrics from configured monitoring targets.
- **Node Exporter** exposes host-level metrics.
- **cAdvisor** provides container resource metrics.
- **Grafana** visualizes metrics and logs.
- **Grafana Alloy** collects configured container and system logs.
- **Loki** stores logs for searching and investigation.
- **Ansible** automates selected baseline configuration tasks.
- **Bash backup automation** creates compressed archives of project and service data.

Actual service availability and configuration depend on the current deployment.

## Security and Observability

### Firewall and Authentication Monitoring

The logging stack is configured to collect selected authentication and UFW firewall logs. These logs can support investigation of blocked connections, authentication events, and other relevant host activity.

### Centralized Logging

Grafana Alloy collects configured logs and forwards them to Loki. Grafana Explore can then be used to search and correlate events.

### Infrastructure Automation

Ansible playbooks and a reusable role manage selected baseline configuration tasks, including package installation, directory and configuration-file management, service state, and a test Compose deployment.

Changes should be reviewed before applying them to a server. The baseline role is not a substitute for a complete security-hardening process.

### Monitoring

Prometheus, Grafana, Node Exporter, and cAdvisor provide visibility into host and container health. Monitoring helps identify operational issues and supports troubleshooting.

## Backup and Recovery

The Bash backup script is designed to:

1. Detect whether the Minecraft container was running.
2. Stop it temporarily when necessary to improve world-data consistency.
3. Create a compressed archive of the project and service data.
4. Check whether the resulting archive can be listed.
5. Attempt to restart Minecraft if the script stopped it.

The script excludes selected local credentials, environment files, generated files, and other private data.

**Important limitations:**
- Archive readability does not prove that a full restore will succeed.
- Restore procedures still need to be tested.
- Exclusion patterns are safeguards, not a guarantee that every secret is removed.
- A backup should be stored securely and protected from unauthorized access.

## Repository Structure

```text
.
├── ansible/
│   ├── inventory/
│   │   └── hosts.example.yml
│   ├── playbooks/
│   ├── roles/
│   └── test-compose/
├── logging/
│   ├── alloy/
│   └── loki/
├── monitoring/
│   └── prometheus/
├── scripts/
│   └── backup.sh
├── docker-compose.yml
└── docker-compose.monitoring.yml
```

The repository structure may evolve as the homelab grows. Local inventory, secrets, persistent application data, and other private runtime files should remain outside the public repository.

## Validation

The following checks have been performed during project review:

- Docker Compose configuration validation.
- Bash syntax validation of the backup script.
- YAML parsing of Ansible and service configuration files.
- Checks that local environment and inventory files are ignored by Git.
- Searches of staged and unstaged changes for common secret patterns.

These checks establish basic syntax and repository hygiene; they do not constitute a full security audit or prove that every service is secure.

## Setup Overview

1. Install Ubuntu Server and Docker Engine with the Compose plugin.
2. Clone the repository to an appropriate project directory.
3. Review the Compose files and customize local settings.
4. Create a private `.env` file for required environment variables.
5. Configure a private Ansible inventory using `ansible/inventory/hosts.example.yml` as a template.
6. Validate configurations before starting or applying services.
7. Review network exposure, firewall rules, credentials, persistent storage, and backup destinations before deployment.

Do not copy example values directly into a live deployment without reviewing them.

## Responsible Use

This project is intended for learning, personal infrastructure administration, and defensive security practice on systems you own or are authorized to manage.

## Roadmap

- [x] Establish an Ubuntu Server foundation.
- [x] Add basic monitoring.
- [x] Develop backup automation.
- [x] Build a centralized logging stack.
- [x] Begin Ansible-based configuration management.
- [ ] Test a complete backup restoration.
- [ ] Add automated configuration and script tests.
- [ ] Review monitoring-service network exposure and access controls.
- [ ] Expand Python-based defensive security tooling.
- [ ] Document security experiments, results, and lessons learned.

## Disclaimer

This is an evolving homelab project. Features, security controls, and validation coverage may change as development continues. Documentation describes the intended design and reviewed configuration, not a guarantee of security.
