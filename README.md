# Redis Cluster Lifecycle Management Tool

## Overview

This project automates the complete lifecycle management of a Redis Cluster using Ansible and Docker.

The implementation covers:

* Cluster Provisioning
* Data Seeding and Verification
* Cluster Monitoring
* Rolling Upgrades
* Full Cluster Verification
* Rollback Testing
* Idempotent Operations
* Structured Logging

The project demonstrates real-world DevOps practices for managing a highly available Redis Cluster while maintaining data integrity during upgrades and operational recovery scenarios.

---

# Architecture

## Cluster Topology

* 6 Redis Nodes
* 3 Masters
* 3 Replicas
* Redis Cluster Enabled
* Docker-Based Infrastructure
* Ansible-Based Automation

### Final Cluster State

* Cluster State: OK
* Slots Assigned: 16384
* Redis Version: 7.2.6
* Data Integrity: PASS

---

# Prerequisites

Install the following tools:

* Docker Engine
* Docker Compose
* Ansible
* Python 3
* Git

Verify installation:

```bash
docker --version
docker compose version
ansible-playbook --version
python3 --version
git --version
```

---

# Bringing Up Infrastructure

Start the Redis container infrastructure:

```bash
cd infra

docker compose up -d --build
```

Verify containers:

```bash
docker ps
```

Expected:

```text
redis-node-1
redis-node-2
redis-node-3
redis-node-4
redis-node-5
redis-node-6
```

---

# Project Commands

## Phase 1 — Provision a Redis Cluster

```bash
./redis-tool provision --version 7.0.15 --masters 3 --replicas-per-master 1
```

Purpose:

* Install Redis
* Configure Redis Cluster
* Create 3 Masters
* Create 3 Replicas
* Configure cluster topology

---

## Phase 2 — Seed Data and Verify

Seed test data:

```bash
./redis-tool data seed --keys 1000
```

Verify data:

```bash
./redis-tool data verify
```

Expected Result:

```text
Verified : 1000
Missing  : 0
Mismatch : 0

PASS
```

This validates data integrity before and after upgrade operations.

---

## Phase 3 — Cluster Status

```bash
./redis-tool status
```

Displays:

* Cluster State
* Redis Version
* Node Roles
* Memory Usage
* Replication Information

Provides a quick operational health view of the cluster.

---

## Phase 4 — Rolling Upgrade

```bash
./redis-tool upgrade --target-version 7.2.6 --strategy rolling
```

Upgrade Path:

```text
Redis 7.0.15 → Redis 7.2.6
```

### Rolling Upgrade Strategy

The implemented strategy follows a high-availability approach.

#### Step 1

Upgrade replica nodes first.

Reason:

Replicas do not serve primary traffic and can be upgraded safely.

#### Step 2

Validate:

* Replica health
* Replication status
* Cluster state

#### Step 3

Upgrade master nodes one at a time.

Reason:

Only one master is affected at a time while the remaining masters continue serving requests.

#### Step 4

Perform post-upgrade validation.

Checks include:

* Cluster health
* Slot coverage
* Replication status
* Version consistency

### Why This Strategy?

Benefits:

* Minimizes risk
* Prevents full cluster outage
* Maintains availability
* Preserves data integrity

Result:

* Zero data loss
* No cluster outage
* Successful upgrade across all nodes

---

## Phase 5 — Full Verification

```bash
./redis-tool verify --full
```

Validation Includes:

* Cluster State
* Slot Coverage
* Version Consistency
* Replica Health
* Data Integrity

Expected Result:

```text
Cluster State       : PASS
Slot Coverage       : PASS
Version Consistency : PASS
Replica Health      : PASS
Data Integrity      : PASS

OVERALL RESULT      : PASS
```

---

# Stretch Goals

## S3 — Rollback (Experimental)

Command:

```bash
./redis-tool rollback --target-version 7.0.15
```

Implemented:

* Rollback workflow automation
* Version downgrade testing
* Recovery validation

Observation:

Redis persistence format compatibility limitations were identified during downgrade testing between Redis 7.2.6 and Redis 7.0.15.

---

## S4 — Idempotency

Implemented:

### Provision

Running provision on an already provisioned cluster:

```text
Cluster already provisioned.
No changes required.
```

### Upgrade

Running upgrade when all nodes already have the target version:

```text
All nodes already running Redis 7.2.6
Nothing to upgrade.
```

This prevents unnecessary operations and makes commands safe to re-run.

---

## S5 — Structured Logging

Implemented operation logging for:

* Provision
* Upgrade
* Verification
* Data Operations
* Rollback

Log File:

```text
logs/redis-tool.log
```

Example:

```text
2026-06-16 17:20:31 | PROVISION_START
2026-06-16 17:20:35 | PROVISION_SKIPPED_ALREADY_EXISTS

2026-06-16 18:12:21 | FULL_VERIFY_START
2026-06-16 18:12:30 | FULL_VERIFY_SUCCESS
```

---

# Issues Encountered and Resolved

## Issue 1 — Ansible Variable Collision

Problem:

Incorrect Redis version validation during upgrade verification.

Root Cause:

Variable name conflict across multiple playbooks.

Fix:

Renamed the conflicting variable to avoid overlap.

---

## Issue 2 — Redis Cluster Startup Failure

Problem:

Redis cluster nodes failed to start.

Root Cause:

Incorrect ownership of cluster metadata files.

Fix:

```bash
chown redis:redis /var/lib/redis/nodes.conf
```

Result:

Redis startup restored successfully.

---

## Issue 3 — AOF Permission Failure

Problem:

Redis failed while loading append-only files.

Root Cause:

AOF files owned by root instead of redis user.

Fix:

```bash
chown -R redis:redis /var/lib/redis
```

Result:

Successful database recovery.

---

## Issue 4 — Recovery After Container Restart

Problem:

Containers were healthy but Redis services were unavailable.

Investigation:

* SSH connectivity worked
* Containers were running
* Redis service unavailable

Resolution:

Automated ownership correction using Ansible across all nodes.

Result:

Cluster recovered successfully.

---

# Assumptions

The implementation assumes:

* Docker Engine is available on the host
* Ansible is installed on the control node
* SSH connectivity exists between Ansible and Redis containers
* Static inventory is used
* Linux/macOS environment is available

---

# Trade-offs

To keep the implementation focused on lifecycle management:

* Fixed 6-node cluster topology
* Static inventory configuration
* Upgrade targets are predefined
* Dynamic cluster scaling was not implemented

These decisions simplified implementation while demonstrating operational automation concepts.

---

# Known Limitations

1. Rollback is experimental and affected by Redis persistence format compatibility between versions.

2. Dynamic Scale-Out (S1) is not implemented.

3. Dynamic Scale-In (S2) is not implemented.

4. Inventory updates are manual.

5. Designed for project and learning environments rather than large-scale production deployments.

---

# Outputs Generated

Generated output files:

```text
output/provision_output.txt
output/status_output.txt
output/upgrade_output.txt
output/verify_output.txt
output/data_verify_output.txt
```

---

# Skills Demonstrated

* Redis Cluster Administration
* Ansible Automation
* Docker Infrastructure Management
* Rolling Upgrade Strategy
* High Availability Concepts
* Linux Troubleshooting
* Production Debugging
* Infrastructure Automation
* DevOps Operations

---

# Final Outcome

Successfully implemented a Redis Cluster Lifecycle Management platform capable of:

* Automated Provisioning
* Data Validation
* Monitoring
* Rolling Upgrades
* Full Verification
* Rollback Testing
* Structured Logging

The final cluster remained healthy throughout provisioning, upgrade, verification, and recovery workflows while maintaining data integrity and cluster availability.
