# Redis Cluster Lifecycle Management Tool

## Objective

The goal of this project is to automate the complete lifecycle management of a Redis Cluster using Ansible and Docker, including provisioning, monitoring, rolling upgrades, verification, and operational recovery.

The implementation focuses on reliability, automation, zero-data-loss upgrades, and operational troubleshooting.

---

# Architecture

Cluster Topology:

* 6 Redis Nodes
* 3 Masters
* 3 Replicas
* Redis Cluster Mode Enabled
* Docker-based deployment
* Ansible-driven automation

Final Cluster State:

* Cluster State: OK
* Slots Assigned: 16384
* Redis Version: 7.2.6
* Data Integrity: PASS

---

# Features Implemented

## Phase 1 - Cluster Provisioning

Automated provisioning of a Redis Cluster consisting of:

* 3 Master nodes
* 3 Replica nodes

Provisioning handled entirely through Ansible.

Key outcome:

* Fully functional Redis Cluster
* Automatic master-replica topology creation

---

## Phase 2 - Data Operations

Implemented:

* Bulk data seeding
* Data verification

Validation Result:

Verified : 1000

Missing : 0

Mismatch : 0

PASS

This ensured data consistency before and after upgrade operations.

---

## Phase 3 - Monitoring and Status Reporting

Implemented a cluster status command:

```bash
./redis-tool status
```

Collected:

* Cluster state
* Redis version
* Node role
* Memory usage
* Replication information

This provides a quick operational health view of the cluster.

---

## Phase 4 - Rolling Upgrade

Upgrade Path:

Redis 7.0.15 → Redis 7.2.6

Upgrade Strategy:

1. Upgrade replicas first
2. Perform controlled failover
3. Upgrade former masters
4. Revalidate cluster health

Result:

* Zero data loss
* No cluster outage
* All nodes upgraded successfully

Final Version:

Redis 7.2.6

---

## Phase 5 - Full Verification

Implemented automated validation of:

* Cluster State
* Slot Coverage
* Version Consistency
* Replica Health
* Data Integrity

Verification Result:

Cluster State : PASS

Slot Coverage : PASS

Version Consistency : PASS

Replica Health : PASS

Data Integrity : PASS

OVERALL RESULT : PASS

---

# Production Issues Encountered and Resolved

A significant part of this project involved troubleshooting real operational failures.

## Issue 1 - Ansible Variable Collision

Problem:

A variable naming conflict caused incorrect version validation.

Root Cause:

Multiple playbooks reused the same variable name.

Fix:

Renamed the conflicting variable to:

precheck_redis_version

---

## Issue 2 - Redis Cluster Startup Failure

Problem:

Redis failed to start after configuration changes.

Root Cause:

nodes.conf ownership mismatch.

Observed Error:

Permission denied while accessing cluster metadata.

Fix:

chown redis:redis /var/lib/redis/nodes.conf

Result:

Redis cluster startup restored.

---

## Issue 3 - AOF Permission Failure

Problem:

Redis startup failed during AOF loading.

Observed Error:

Permission denied opening appendonly.aof

Root Cause:

AOF files owned by root instead of redis user.

Fix:

chown -R redis:redis /var/lib/redis

Result:

Successful database recovery.

---

## Issue 4 - Recovery After Docker Restart

Problem:

Containers were healthy but Redis processes were not running.

Investigation:

* SSH connectivity worked
* Containers were running
* Redis service unavailable

Root Cause:

Incorrect ownership of persistence files after restart.

Resolution:

Automated ownership correction using Ansible across all nodes.

Result:

All Redis instances restored successfully.

---

# Outputs

Generated project outputs:

* provision_output.txt
* status_output.txt
* upgrade_output.txt
* verify_output.txt
* data_verify_output.txt

---

# Skills Demonstrated

* Redis Cluster Administration
* Ansible Automation
* Rolling Upgrade Strategy
* High Availability Concepts
* Failure Recovery
* Linux Troubleshooting
* Infrastructure Automation
* Production Debugging
* DevOps Operations

---

# Final Outcome

Successfully implemented an end-to-end Redis Cluster Lifecycle Management platform capable of:

* Automated provisioning
* Monitoring
* Data validation
* Rolling upgrades
* Health verification
* Operational recovery

The final cluster remained healthy throughout upgrade and recovery workflows with zero data loss.
