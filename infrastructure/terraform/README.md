# ConnectBridge — Terraform Infrastructure

## Overview

This directory contains the Infrastructure as Code configuration for the ConnectBridge local development environment.

Terraform provisions and manages Docker infrastructure required for standalone container development and infrastructure validation.

The implementation is entirely local and does not require a cloud provider.

## Objectives

- Automate infrastructure provisioning.
- Maintain reproducible infrastructure configuration.
- Manage infrastructure state securely.
- Validate infrastructure idempotency.
- Detect and remediate infrastructure drift.
- Verify container networking and service discovery.
- Validate persistent storage functionality.
- Establish documented infrastructure recovery procedures.

## Technology Stack

| Technology | Version |
|---|---|
| Terraform | 1.17.2 |
| Terraform Docker Provider | 4.7.0 |
| Docker Engine | 29.10.1 |
| Operating System | Ubuntu 26.04.1 LTS |
| Functional Test Image | BusyBox 1.37.0 |

## Directory Structure

| File | Responsibility |
|---|---|
| versions.tf | Terraform and provider version requirements |
| providers.tf | Docker provider configuration |
| variables.tf | Infrastructure input variables |
| main.tf | Infrastructure resource definitions |
| outputs.tf | Infrastructure output values |
| terraform.tfvars.example | Example environment configuration |
| .terraform.lock.hcl | Provider dependency lock file |
| README.md | Infrastructure documentation |

## Managed Infrastructure

### Docker Network

- Name: connectbridge-dev
- Driver: bridge
- Scope: local
- Observed subnet: 172.18.0.0/16
- Observed gateway: 172.18.0.1
- IPv4: enabled
- IPv6: disabled

The network provides container-to-container communication and Docker-based service discovery.

The subnet and gateway are automatically allocated by Docker and are not guaranteed to remain identical across deployments.

### Persistent Volume

- Name: connectbridge-dev-data
- Driver: local
- Scope: local

The volume provides persistent storage independent of the container lifecycle.

Applications should access the volume through container mounts rather than directly modifying Docker's internal storage directory.

## Resource Management Labels

Both infrastructure resources use the following labels:

| Label | Value |
|---|---|
| project | connectbridge |
| environment | dev |
| managed-by | terraform |

These labels support resource identification, ownership and operational management.

## Input Variables

| Variable | Default value |
|---|---|
| project_name | connectbridge |
| environment | dev |
| network_driver | bridge |
| volume_driver | local |

Supported environment values are dev, test and uat.

Changing the environment variable within the same Terraform state may replace existing resources. Separate environments require appropriately isolated state management.

## Prerequisites

- Terraform installed.
- Docker Engine installed and running.
- Docker socket accessible to the executing user.
- Internet connectivity for initial provider and container image downloads.

## Infrastructure Provisioning

Run the following commands from the infrastructure/terraform directory.

### Initialize Terraform

```bash
terraform init
```

### Validate Configuration

```bash
terraform fmt -check
terraform validate
```

### Generate Execution Plan

```bash
terraform plan -out=connectbridge.tfplan
```

### Review Execution Plan

```bash
terraform show connectbridge.tfplan
```

### Provision Infrastructure

```bash
terraform apply connectbridge.tfplan
```

### Inspect Managed Resources

```bash
terraform state list
terraform output
docker network ls
docker volume ls
```

## Infrastructure State Management

Terraform uses local state to maintain the relationship between configuration and provisioned infrastructure.

The state file must not be manually edited, deleted or committed to version control.

State files, state backups and saved execution plans are excluded from Git.

Restrict access to sensitive Terraform artifacts using appropriate file permissions.

```bash
umask 077
chmod 600 terraform.tfstate
```

The provider dependency lock file must be committed to ensure consistent provider selection.

## Idempotency Verification

Infrastructure convergence is verified using:

```bash
terraform plan -detailed-exitcode
echo "Terraform plan exit code: $?"
```

| Exit Code | Meaning |
|---|---|
| 0 | Successful plan with no changes |
| 1 | Planning error |
| 2 | Successful plan containing proposed changes |

Initial provisioning and post-recovery validation both returned exit code 0 when the infrastructure matched its configuration.

## Infrastructure Drift and Recovery

A controlled infrastructure failure exercise was performed to validate Terraform's recovery capabilities.

### Incident Scenario

The unused ConnectBridge Docker network was manually removed outside Terraform after confirming that no containers were attached.

The persistent volume was preserved throughout the exercise.

### Recovery Procedure

1. Establish a healthy infrastructure baseline.
2. Verify infrastructure idempotency.
3. Back up Terraform state.
4. Confirm the network has no attached containers.
5. Introduce controlled network deletion.
6. Detect infrastructure drift using Terraform.
7. Review the proposed recovery plan.
8. Apply the reviewed recovery plan.
9. Verify restored infrastructure.
10. Confirm infrastructure convergence.

### Recovery Results

| Metric | Result |
|---|---|
| Resources proposed for creation | 1 |
| Resources proposed for modification | 0 |
| Resources proposed for destruction | 0 |
| Drift detection exit code | 2 |
| Network recovery | Successful |
| Persistent volume preservation | Successful |
| Post-recovery plan exit code | 0 |

The recovered network received a new resource identifier while retaining its name, management labels and observed network configuration.

## Functional Testing

Infrastructure functional testing was performed using BusyBox containers.

| Test ID | Description | Result |
|---|---|---|
| TF-001 | Container network attachment | Passed |
| TF-002 | Docker DNS resolution | Passed |
| TF-003 | Container-to-container HTTP communication | Passed |
| TF-004 | Persistent volume write | Passed |
| TF-005 | Persistent volume read | Passed |
| TF-006 | Data persistence after container removal | Passed |
| TF-007 | Temporary container cleanup | Passed |
| TF-008 | Final Terraform idempotency | Passed |

### Network Testing

Two temporary containers were used to verify internal DNS resolution and HTTP communication.

Docker's embedded DNS server successfully resolved the test server hostname.

The HTTP client received the expected response from the server without publishing any host ports.

### Persistent Storage Testing

A temporary writer container stored test data in the Terraform-managed volume.

The writer container was removed, and a separate reader container mounted the same volume in read-only mode.

The reader successfully retrieved and validated the original data.

## Troubleshooting

### Obsolete Docker Desktop Credential Helper

During functional testing, Docker image downloads initially failed because the client configuration referenced the previously uninstalled Docker Desktop credential helper.

Error:

```text
docker-credential-desktop: executable file not found in $PATH
```

The obsolete credential store setting was identified, and a targeted configuration repair was provided.

A subsequent public BusyBox image download succeeded.

Authenticated registry access requires separate verification and an appropriate supported credential storage mechanism.

## Security Considerations

- No infrastructure credentials are hardcoded in Terraform configuration.
- Terraform state and saved execution plans are excluded from Git.
- Local state files and backups use owner-only permissions.
- Provider versions are explicitly pinned.
- Infrastructure changes are reviewed before execution.
- Temporary HTTP testing does not publish host ports.
- Storage verification uses a read-only reader mount.
- Persistent volumes are preserved during network recovery exercises.

Docker socket access provides privileged control over the host and must be restricted to trusted users.

## Operational Limitations

- Terraform state is stored locally.
- The Docker network is not configured as an internal-only network.
- Persistent storage is local to the host.
- Container-level persistence does not provide protection against disk failure.
- Database backup and restoration have not yet been tested.
- The network recovery exercise does not demonstrate application-level disaster recovery.
- The Docker network and volume are intended for standalone development and do not automatically provide Kubernetes networking or persistent storage.

## Final Validation

Validation date: 27 November 2026

- Terraform configuration: valid.
- Terraform formatting: passed.
- Managed infrastructure resources: 2.
- Temporary containers remaining: 0.
- Connected network containers: 0.
- Infrastructure convergence: verified.
- Final Terraform plan exit code: 0.

## Next Phase

Ansible configuration automation will establish repeatable host validation, environment preparation and operational configuration workflows before local Kubernetes cluster provisioning with Kind.
