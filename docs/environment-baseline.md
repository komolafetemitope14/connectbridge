
# ConnectBridge - Environment Baseline

## 1. Purpose

This document records the initial development environment,
infrastructure tools, operational constraints and resource
management strategy for ConnectBridge.

Baseline date: 27 November 2026

## 2. Hardware Environment

| Component | Specification |
|---|---|
| Computer | Lenovo ThinkPad T480 |
| Processor | Intel Core i7-8550U |
| Logical CPUs | 8 |
| Available Physical Memory | Approximately 14 GiB |
| Architecture | AMD64 / x86_64 |
| Deployment Environment | Local workstation |
| Public Cloud Infrastructure | Not required |

Available CPU, memory and storage shall be checked before
infrastructure provisioning.

## 3. Operating System

| Component | Version |
|---|---|
| Distribution | Ubuntu |
| Release | 26.04.1 LTS |
| Codename | Resolute Raccoon |
| Kernel | 7.0.0-44-generic |
| Architecture | Linux AMD64 |

## 4. Verified Infrastructure Tools

| Tool | Installed Version | Purpose |
|---|---|---|
| Docker Engine | 29.10.1 | Container runtime environment |
| Docker CLI | 29.10.1 | Container management |
| containerd | 2.4.2 | Container lifecycle management |
| runc | 1.5.3 | Low-level container runtime |
| Docker Compose | 5.8.0 | Multi-container development |
| Docker Buildx | 0.39.1 | Container image builds |
| Terraform | 1.17.2 | Infrastructure provisioning |
| Ansible Core | 2.20.1 | Configuration automation |
| kubectl | 1.37.3 | Kubernetes administration |
| Kustomize | 5.8.1 | Kubernetes configuration customization |
| Kind | 0.33.0 | Local Kubernetes cluster |
| Helm | 4.3.2 | Kubernetes application deployment |
| Trivy | 0.76.2 | Vulnerability and configuration scanning |
| OpenJDK | 21.0.13.1 | Java application development |
| Maven | 3.9.12 | Java build and dependency management |
| Python | 3.14.4 | Automation and scripting |

## 5. Docker Environment

Docker Engine is installed natively on Ubuntu.

Docker Desktop is not required for ConnectBridge.

Verified configuration:

- Active Docker context: default
- Docker endpoint: unix:///var/run/docker.sock
- Non-root Docker execution: verified
- Docker daemon connectivity: verified
- Docker Hub connectivity: verified
- Container creation and execution: verified
- Docker Compose version: verified
- Docker Buildx version: verified

Membership in the Docker group provides privileged access
to the host and must be treated accordingly.

## 6. Java Development Environment

ConnectBridge shall use Java 21.

Project Java home:

    /usr/lib/jvm/java-21-openjdk-amd64

Maven execution using Java 21:

    JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 mvn --version

The existing host Java environment shall not be removed
or unnecessarily modified.

## 7. Infrastructure Ownership

| Resource | Responsible Tool |
|---|---|
| Selected Docker infrastructure resources | Terraform |
| Host configuration and preflight checks | Ansible |
| Kubernetes cluster lifecycle | Kind |
| Kubernetes administration | kubectl |
| Application container images | Docker |
| Kubernetes application releases | Helm |
| Vulnerability and configuration scanning | Trivy |
| Java application builds | Maven |
| Source control | Git |
| Continuous integration | GitHub Actions |

Infrastructure ownership shall be clearly defined to prevent
conflicting resource management.

## 8. Proposed Resource Strategy

The initial Kubernetes environment shall use a single
control-plane node.

Application services shall be introduced incrementally.

Initial engineering guidelines:

- Preserve sufficient memory for the host operating system.
- Avoid unnecessary background workloads.
- Measure resource consumption after each deployment.
- Introduce CPU and memory requests and limits.
- Avoid exposing unnecessary service ports.
- Avoid modifying unrelated host databases.
- Use project-specific persistent storage.
- Document resource requirements and observed limitations.

Resource allocations shall be refined through measurement
rather than treated as guaranteed capacity.

## 9. Infrastructure Isolation

ConnectBridge shall maintain separation from existing
applications and host services.

The project shall use:

- Dedicated infrastructure resource names.
- Project-specific Kubernetes namespaces.
- Dedicated application databases and credentials.
- Project-specific persistent storage.
- Controlled network exposure.
- Version-controlled infrastructure configuration.

Existing host PostgreSQL and MySQL installations shall not
be modified as part of ConnectBridge provisioning.

## 10. Dependency Management

Installed infrastructure tool versions represent the
initial development baseline.

The following shall be selected and pinned during
implementation:

- Terraform providers.
- Kubernetes node images.
- Spring Boot dependencies.
- Apache Camel dependencies.
- PostgreSQL container images.
- RabbitMQ container images.
- Keycloak container images.
- Kong container images.
- Grafana container images.
- Grafana Loki container images.
- Grafana Alloy container images.
- Helm charts.

Terraform dependency lock files shall be committed
to version control.

Application dependency compatibility shall be validated
before deployment.

## 11. Security Baseline

- No credentials committed to source control.
- No Terraform state committed to source control.
- No private keys committed to source control.
- No Kubernetes credentials committed to source control.
- Container images scanned before release.
- Infrastructure configurations scanned before deployment.
- Sensitive application logs redacted.
- Least-privilege access applied where practical.
- Internal services exposed only where necessary.

## 12. Verification Status

| Verification | Status |
|---|---|
| Docker daemon connectivity | Passed |
| Docker container execution | Passed |
| Non-root Docker execution | Passed |
| Infrastructure tool version checks | Passed |
| Java 21 execution | Passed |
| Maven execution with Java 21 | Passed |
| Git repository configuration | Passed |
| Git exclusion rule checks | Passed |
| Terraform provider initialization | Pending |
| Terraform resource provisioning | Pending |
| Ansible playbook execution | Pending |
| Kubernetes cluster creation | Pending |
| Helm application deployment | Pending |
| Trivy vulnerability scanning | Pending |

Version verification confirms tool availability but does
not establish full operational compatibility.

## 13. Environment Change Management

Future infrastructure changes shall be documented with:

- Date of change.
- Component affected.
- Previous version.
- New version.
- Reason for change.
- Compatibility verification.
- Rollback procedure where applicable.
