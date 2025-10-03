# Azure Resiliency Assessment Tasks

## Overview

This document provides a comprehensive checklist for assessing Azure resource resiliency based on the [Azure Proactive Resiliency Library v2](https://azure.github.io/Azure-Proactive-Resiliency-Library-v2/azure-resources/). 

Each Azure service is evaluated across six key categories:
- **High Availability** (HA): Ensures service continuity and fault tolerance
- **Disaster Recovery** (DR): Protects against regional failures and data loss
- **Monitoring and Alerting** (MA): Provides visibility into service health
- **Scalability** (SC): Ensures performance under load
- **Security** (SE): Protects against threats and vulnerabilities
- **Other Best Practices** (BP): General operational excellence

## Assessment Structure

For each service, evaluate:
1. ✅ **COMPLIANT** - Requirement is met
2. ❌ **NON-COMPLIANT** - Requirement is not met, needs remediation
3. ⚠️ **PARTIAL** - Partially implemented, needs review
4. ❓ **NOT APPLICABLE** - Not relevant to current environment

---

## Identity and Access Management

### AAD Domain Services
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable domain services in multiple regions | ⬜ | |
| Medium | SE | Configure secure LDAP (LDAPS) | ⬜ | |
| Medium | MA | Monitor domain services health | ⬜ | |

---

## API Management

### API Management Services
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across multiple availability zones | ⬜ | |
| High | DR | Configure backup and restore policies | ⬜ | |
| Medium | SC | Implement caching strategies | ⬜ | |
| Medium | SE | Enable API gateway security policies | ⬜ | |
| Low | MA | Configure API analytics and monitoring | ⬜ | |

---

## Container Services

### Container Apps
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across multiple availability zones | ⬜ | |
| High | SC | Configure horizontal pod autoscaling | ⬜ | |
| Medium | DR | Implement container image backup strategy | ⬜ | |
| Medium | MA | Enable container insights monitoring | ⬜ | |

### Managed Environments (Container Apps)
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Configure multiple subnets for redundancy | ⬜ | |
| Medium | SE | Enable network security policies | ⬜ | |

### Container Registry
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable geo-replication for registries | ⬜ | |
| Medium | DR | Configure registry backup policies | ⬜ | |
| Medium | SE | Enable container image scanning | ⬜ | |
| Low | MA | Monitor registry usage and performance | ⬜ | |

### AKS (Azure Kubernetes Service)
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across multiple availability zones | ⬜ | |
| High | SC | Configure cluster autoscaler | ⬜ | |
| High | SE | Enable Azure Policy for AKS | ⬜ | |
| Medium | DR | Implement backup for persistent volumes | ⬜ | |
| Medium | MA | Enable Container Insights | ⬜ | |

---

## App Configuration

### Configuration Stores
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable geo-replication | ⬜ | |
| Medium | DR | Implement configuration backup | ⬜ | |
| Medium | SE | Configure private endpoints | ⬜ | |

---

## Automation

### Automation Accounts
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | DR | Backup automation account configurations | ⬜ | |
| Medium | SE | Use managed identity for authentication | ⬜ | |
| Low | MA | Monitor automation job execution | ⬜ | |

---

## Azure VMware Solution (AVS)

### Private Clouds
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across multiple hosts | ⬜ | |
| High | DR | Configure Site Recovery Manager | ⬜ | |
| Medium | MA | Enable vSphere monitoring | ⬜ | |

---

## Batch

### Batch Accounts
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Configure pool across multiple zones | ⬜ | |
| Medium | SC | Enable auto-scaling for pools | ⬜ | |
| Low | MA | Monitor batch job performance | ⬜ | |

---

## Cache

### Redis Cache
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable Redis clustering | ⬜ | |
| High | DR | Configure geo-replication | ⬜ | |
| Medium | SE | Enable Redis AUTH | ⬜ | |
| Low | MA | Monitor cache performance metrics | ⬜ | |

---

## CDN

### CDN Profiles
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Use multiple edge locations | ⬜ | |
| Medium | SE | Configure HTTPS and security rules | ⬜ | |
| Low | MA | Monitor CDN performance and usage | ⬜ | |

---

## Cognitive Services

### Cognitive Services Accounts
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across multiple regions | ⬜ | |
| Medium | DR | Implement model backup strategies | ⬜ | |
| Medium | SE | Configure private endpoints | ⬜ | |
| Low | MA | Monitor API usage and performance | ⬜ | |

---

## Compute

### Virtual Machines
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Run production workloads on two or more VMs using VMSS Flex | ⬜ | |
| High | HA | Deploy VMs across Availability Zones | ⬜ | |
| High | HA | Migrate VMs using availability sets to VMSS Flex | ⬜ | |
| High | HA | Use Managed Disks for VM disks | ⬜ | |
| High | HA | Reserve Compute Capacity for critical workloads | ⬜ | |
| High | SC | Don't use A or B-Series VMs for production needing constant full CPU performance | ⬜ | |
| High | SC | Mission Critical Workloads should consider using Premium or Ultra Disks | ⬜ | |
| Medium | DR | Replicate VMs using Azure Site Recovery | ⬜ | |
| Medium | DR | Backup VMs with Azure Backup service | ⬜ | |
| Medium | DR | Reserve Compute Capacity in Disaster Recovery Regions | ⬜ | |
| Medium | SC | Enable Accelerated Networking (AccelNet) | ⬜ | |
| Medium | HA | Use maintenance configurations for Dedicated/Isolated VM SKUs | ⬜ | |
| Medium | HA | Use Azure Boost VMs for Maintenance sensitive workloads | ⬜ | |
| Medium | HA | Enable Scheduled Events for Maintenance sensitive workloads | ⬜ | |
| Medium | BP | IP Forwarding should only be enabled for Network Virtual Appliances | ⬜ | |
| Low | BP | When AccelNet is enabled, manually update the GuestOS NIC driver | ⬜ | |
| Low | MA | Enable VM Insights | ⬜ | |

### Disks
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Use Premium SSD or Ultra Disks for critical workloads | ⬜ | |
| High | DR | Enable disk encryption | ⬜ | |
| Medium | DR | Create disk snapshots regularly | ⬜ | |

### Virtual Machine Scale Sets
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across multiple availability zones | ⬜ | |
| High | SC | Configure auto-scaling rules | ⬜ | |
| Medium | DR | Implement backup strategies | ⬜ | |

### Galleries (Shared Image Gallery)
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | DR | Replicate images across regions | ⬜ | |
| Low | MA | Monitor image usage | ⬜ | |

---

## Dashboard

### Grafana
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Configure high availability setup | ⬜ | |
| Medium | DR | Backup dashboard configurations | ⬜ | |
| Low | SE | Configure authentication and RBAC | ⬜ | |

---

## Data Services

### Databricks Workspaces
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| Medium | DR | Implement workspace backup | ⬜ | |
| Medium | SE | Configure private endpoints | ⬜ | |

### MySQL Flexible Servers
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable zone redundant high availability | ⬜ | |
| High | DR | Configure automated backups | ⬜ | |
| Medium | DR | Set up read replicas for disaster recovery | ⬜ | |
| Medium | SE | Enable private network access | ⬜ | |

### PostgreSQL Flexible Servers
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable zone redundant high availability | ⬜ | |
| High | DR | Configure automated backups | ⬜ | |
| Medium | DR | Set up read replicas for disaster recovery | ⬜ | |
| Medium | SE | Enable private network access | ⬜ | |

---

## Desktop Virtualization

### Host Pools (AVD)
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| Medium | SC | Configure appropriate VM sizes | ⬜ | |
| Low | MA | Enable session host monitoring | ⬜ | |

### Scaling Plans (AVD)
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | SC | Configure auto-scaling policies | ⬜ | |
| Low | MA | Monitor scaling events | ⬜ | |

---

## Devices

### IoT Hubs
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Use Standard tier with multiple units | ⬜ | |
| Medium | DR | Configure IoT Hub disaster recovery | ⬜ | |
| Medium | SE | Enable device authentication | ⬜ | |
| Low | MA | Monitor IoT Hub metrics | ⬜ | |

---

## Document DB (Cosmos DB)

### Database Accounts
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable multi-region writes | ⬜ | |
| High | HA | Configure automatic failover | ⬜ | |
| High | DR | Enable continuous backup | ⬜ | |
| Medium | SE | Configure private endpoints | ⬜ | |
| Low | MA | Monitor request units and performance | ⬜ | |

---

## Event Services

### Event Grid Topics
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Configure multiple event handlers | ⬜ | |
| Medium | DR | Implement dead letter queues | ⬜ | |
| Low | MA | Monitor event delivery success | ⬜ | |

### Event Hub Namespaces
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable zone redundancy | ⬜ | |
| Medium | DR | Configure geo-disaster recovery | ⬜ | |
| Medium | SC | Configure appropriate throughput units | ⬜ | |
| Low | MA | Monitor throughput and latency | ⬜ | |

---

## Insights (Application Insights)

### Components
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | MA | Configure appropriate sampling rates | ⬜ | |
| Medium | MA | Set up availability tests | ⬜ | |
| Low | DR | Export telemetry data for backup | ⬜ | |

### Activity Log Alerts
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | MA | Configure critical resource alerts | ⬜ | |
| Low | MA | Set up action groups for notifications | ⬜ | |

---

## Key Vault

### Vaults
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | SE | Enable soft delete and purge protection | ⬜ | |
| High | SE | Use Azure RBAC for access control | ⬜ | |
| Medium | DR | Configure vault backup | ⬜ | |
| Medium | SE | Enable private endpoints | ⬜ | |
| Low | MA | Monitor key vault access logs | ⬜ | |

---

## Machine Learning

### ML Workspaces
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | SE | Configure private endpoints | ⬜ | |
| Medium | DR | Backup workspace configurations | ⬜ | |
| Low | MA | Monitor compute usage | ⬜ | |

### ML Registries
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | DR | Replicate models across regions | ⬜ | |
| Low | SE | Configure access controls | ⬜ | |

---

## NetApp

### NetApp Accounts
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | DR | Configure cross-region replication | ⬜ | |
| Medium | DR | Implement snapshot policies | ⬜ | |
| Low | MA | Monitor performance metrics | ⬜ | |

---

## Network

### Application Gateways
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| Medium | SE | Configure Web Application Firewall | ⬜ | |
| Medium | SC | Configure auto-scaling | ⬜ | |
| Low | MA | Monitor application gateway metrics | ⬜ | |

### Azure Firewalls
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| Medium | SE | Configure threat intelligence | ⬜ | |
| Low | MA | Monitor firewall logs and metrics | ⬜ | |

### Bastion Hosts
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Deploy across availability zones | ⬜ | |
| Low | SE | Configure session monitoring | ⬜ | |

### VPN Connections
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Configure redundant connections | ⬜ | |
| Medium | MA | Monitor connection health | ⬜ | |

### DDoS Protection Plans
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | SE | Enable DDoS protection standard | ⬜ | |
| Low | MA | Monitor DDoS attack metrics | ⬜ | |

### DNS Zones
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Use multiple name servers | ⬜ | |
| Low | MA | Monitor DNS query performance | ⬜ | |

### ExpressRoute Circuits
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Configure redundant circuits | ⬜ | |
| Medium | MA | Monitor circuit utilization | ⬜ | |

### ExpressRoute Gateways
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| Medium | SC | Configure appropriate gateway SKU | ⬜ | |

### ExpressRoute Ports
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Configure redundant ports | ⬜ | |
| Low | MA | Monitor port utilization | ⬜ | |

### Load Balancers
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| Medium | MA | Configure health probes | ⬜ | |
| Low | MA | Monitor load balancer metrics | ⬜ | |

### NAT Gateways
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| Low | MA | Monitor outbound connections | ⬜ | |

### Network Security Groups
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | SE | Implement least privilege access | ⬜ | |
| Low | MA | Enable NSG flow logs | ⬜ | |

### Network Watchers
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Low | MA | Configure network monitoring | ⬜ | |

### P2S VPN Gateways
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Configure redundant gateways | ⬜ | |
| Medium | SE | Use certificate-based authentication | ⬜ | |

### Private DNS Zones
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Link to multiple virtual networks | ⬜ | |

### Private Endpoints
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | SE | Configure for critical services | ⬜ | |
| Low | MA | Monitor private endpoint connections | ⬜ | |

### Public IP Addresses
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Use Standard SKU for production | ⬜ | |
| Low | MA | Monitor IP address usage | ⬜ | |

### Route Tables
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | SE | Implement secure routing policies | ⬜ | |

### Traffic Manager Profiles
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Configure multiple endpoints | ⬜ | |
| Medium | MA | Monitor endpoint health | ⬜ | |

### Virtual Hubs
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| Low | MA | Monitor hub connectivity | ⬜ | |

### Virtual Network Gateways
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Configure active-active setup | ⬜ | |
| Medium | MA | Monitor gateway performance | ⬜ | |

### Virtual Networks
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Design for multiple availability zones | ⬜ | |
| Medium | SE | Implement network segmentation | ⬜ | |

### Virtual Routers
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Configure redundant routers | ⬜ | |

### VPN Gateways
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Configure active-active setup | ⬜ | |
| Medium | MA | Monitor VPN connectivity | ⬜ | |

### VPN Sites
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | HA | Configure redundant site connections | ⬜ | |

---

## Network Function

### Azure Traffic Collectors
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Low | MA | Monitor traffic collection performance | ⬜ | |

---

## Operational Insights

### Workspaces (Log Analytics)
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | DR | Configure workspace backup | ⬜ | |
| Medium | MA | Set up appropriate retention policies | ⬜ | |
| Low | SE | Configure access controls | ⬜ | |

---

## Oracle Database

### Cloud Exadata Infrastructures
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Configure Oracle RAC | ⬜ | |
| High | DR | Set up Oracle Data Guard | ⬜ | |

### Cloud VM Clusters
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across fault domains | ⬜ | |
| Medium | DR | Configure backup policies | ⬜ | |

---

## Recovery Services

### Vaults
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | DR | Configure geo-redundant storage | ⬜ | |
| High | DR | Set up appropriate backup policies | ⬜ | |
| Medium | SE | Enable soft delete | ⬜ | |
| Low | MA | Monitor backup success rates | ⬜ | |

---

## Service Bus

### Namespaces
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable zone redundancy | ⬜ | |
| Medium | DR | Configure geo-disaster recovery | ⬜ | |
| Medium | SC | Configure appropriate messaging units | ⬜ | |
| Low | MA | Monitor message throughput | ⬜ | |

---

## SignalR Service

### SignalR
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Use Standard tier with multiple units | ⬜ | |
| Medium | SC | Configure auto-scaling | ⬜ | |
| Low | MA | Monitor connection metrics | ⬜ | |

---

## SQL

### Servers
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Enable zone redundancy for Azure SQL Database | ⬜ | |
| High | DR | Use Failover Group endpoints for database connections | ⬜ | |
| High | DR | Use failover group customer managed policy | ⬜ | |
| Medium | DR | Back Up Your Keys | ⬜ | |

### Managed Instances
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| High | DR | Configure auto-failover groups | ⬜ | |
| Medium | DR | Set up automated backups | ⬜ | |
| Low | MA | Monitor performance metrics | ⬜ | |

---

## Storage

### Storage Accounts
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Ensure that storage accounts are zone or region redundant | ⬜ | |
| Medium | DR | Enable Soft Delete to protect your data | ⬜ | |
| Low | DR | Enable versioning for accidental modification and keep versions below 1000 | ⬜ | |
| Low | DR | Enable point-in-time restore for GPv2 accounts | ⬜ | |
| Low | MA | Monitor all blob storage accounts | ⬜ | |
| Low | SC | Consider upgrading legacy storage accounts to v2 | ⬜ | |

---

## Stream Analytics

### Streaming Jobs
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | SC | Configure appropriate streaming units | ⬜ | |
| Medium | MA | Monitor job performance and errors | ⬜ | |
| Low | DR | Implement job configuration backup | ⬜ | |

---

## Subscription

### Subscriptions
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | SE | Configure resource locks for critical resources | ⬜ | |
| Medium | MA | Set up budget alerts | ⬜ | |
| Low | SE | Implement Azure Policy for governance | ⬜ | |

---

## Virtual Machine Images

### Image Templates
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| Medium | DR | Replicate image templates across regions | ⬜ | |
| Low | SE | Secure image template configurations | ⬜ | |

---

## Web

### Server Farms (App Service Plans)
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | HA | Deploy across availability zones | ⬜ | |
| High | SC | Configure auto-scaling rules | ⬜ | |
| Medium | SC | Use appropriate pricing tier for workload | ⬜ | |

### Sites (App Services/Function Apps)
| Priority | Category | Requirement | Status | Notes |
|----------|----------|-------------|---------|-------|
| High | MA | Monitor Performance | ⬜ | |
| High | BP | Enable Health check for App Services | ⬜ | |
| Medium | DR | Create a separate storage account for logs | ⬜ | |
| Medium | BP | Store configuration as app settings for Web Sites | ⬜ | |
| Medium | BP | Store configuration as app settings for Web Site Slots | ⬜ | |
| Medium | MA | No warmup trigger added to Function App | ⬜ | |
| Medium | BP | Ensure Function App runs a supported version | ⬜ | |
| Medium | BP | Ensure FUNCTIONS_WORKER_RUNTIME is set properly | ⬜ | |
| Low | MA | Enable diagnostics logging | ⬜ | |
| Low | SC | Separate web apps from web APIs | ⬜ | |
| Low | BP | Deploy to a staging slot | ⬜ | |
| Low | HA | Enable auto heal for Functions App | ⬜ | |
| Low | BP | Ensure unique hostid set for Function App | ⬜ | |

---

## Assessment Summary

### Compliance Overview
- **Total Requirements**: [Count after assessment]
- **Compliant**: ✅ [Count]
- **Non-Compliant**: ❌ [Count]
- **Partial**: ⚠️ [Count]
- **Not Applicable**: ❓ [Count]

### Priority Remediation Items
1. **High Priority Issues**: [List critical non-compliant items]
2. **Medium Priority Issues**: [List important non-compliant items]
3. **Low Priority Issues**: [List nice-to-have non-compliant items]

### Recommendations
1. **Immediate Actions**: [Critical remediation steps]
2. **Short-term Actions**: [Important improvements]
3. **Long-term Actions**: [Strategic enhancements]

---

## Resources and Tools

### Azure Resource Graph Queries
Each requirement in the Azure Proactive Resiliency Library includes Azure Resource Graph (ARG) queries for automated assessment. Consider implementing these queries for continuous compliance monitoring.

### Assessment Automation
- **Azure Resource Graph**: Query Azure resources at scale
- **Azure Policy**: Implement governance and compliance checks
- **Azure Advisor**: Get personalized recommendations
- **Azure Well-Architected Review**: Comprehensive architecture assessment

### Documentation References
- [Azure Proactive Resiliency Library v2](https://azure.github.io/Azure-Proactive-Resiliency-Library-v2/)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
- [Azure Well-Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/)

---

*Last updated: September 29, 2025*