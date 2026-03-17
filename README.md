# Azure VM Blueprint for Kubeadm ☸️ ☁️

This repository contains a standardized Terraform configuration designed to rapidly bootstrap Azure infrastructure specifically for **Kubeadm Kubernetes deployments**. 

It streamlines the process of creating multiple VMs and Virtual Networks (VNets), ensuring that networking is pre-configured for cluster communication.



---

## 🎯 Purpose
Manually setting up VNets and VMs for Kubernetes testing is time-consuming and prone to configuration errors (overlapping CIDRs, firewall blocks). This blueprint:
* Automatically provisions the required **Compute** (Ubuntu/Windows) and **Networking** (VNet/Subnet/PIP).
* Ensures **Non-overlapping address spaces** using 192.168.0.0/16 logic.
* Pre-configures **Public IPs** and **Network Interfaces** for immediate Kubeadm initialization.

---

## 🏗️ Architecture Overview

| Component | Specification |
| :--- | :--- |
| **Regions** | Selection: `centralindia`, `eastasia`, `australiaeast` |
| **OS Options** | Ubuntu Server 24.04 LTS or Windows Server 2019 Datacenter |
| **Networking** | Unique /24 Subnets per VNet |
| **Authentication** | Password-based (Standardized for Lab environments) |
| **Security** | Standard SKU Public IPs for all instances |

---

## 🚀 Getting Started

### 1. Prerequisites
* [Terraform](https://www.terraform.io/downloads.html) installed locally.
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated (`az login`).

### 2. Configuration
The code will prompt you for inputs, or you can create a `terraform.tfvars` file:

```hcl
vm_count               = 3
vnet_count             = 1
distribute_across_vnets = false
location               = "centralindia"
image_selection        = "ubuntu"

```

### 3. Select the right Azure subscription (if in case you have multiple susbcriptions)

List your subscriptions:

```bash
az account list --output table
```

Set the defaut subscription:

```bash
az account set --subscription <subscription_ID>
```

Verify the result:

```bash
az account show --output table
```

### 4. Deployment

```bash
terraform init
terraform plan
terraform apply
```
---

## 📂 Repository Structure

The project is modularized to separate networking logic from compute resources, following Terraform best practices.

| File | Description |
| :--- | :--- |
| **variables.tf** | Defines user input definitions, including region validation and OS image selection. |
| **network.tf** | Contains the core logic for Virtual Networks (VNets), Subnets, and Resource Group management. |
| **compute.tf** | Manages Virtual Machine (VM) logic, OS Disk lifecycle, and Public IP assignments. |
| **outputs.tf** | Returns the VM Names and Public IP addresses in a clean list upon successful deployment. |



---
