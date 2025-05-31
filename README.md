# 🐳 Multi-Node Docker Swarm Environment with Vagrant & Nginx Proxy

This repository sets up a full **multi-node Docker Swarm cluster** using **Vagrant**, **VirtualBox**, and **Docker Compose v3.9**. It includes a sample microservices architecture with:

![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)

---

## Prerequisites

### Core Tools
1. **Vagrant** (for VM provisioning):  
   📥 [Download Vagrant](https://www.vagrantup.com/downloads)  
   *Minimum version: 2.2.19*  
   *Verify installation:*  
   ```bash
   vagrant --version
   ```

2. **VirtualBox** (hypervisor for VMs):  
   📥 [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)  
   *Minimum version: 6.1*  
   *Verify installation:*  
   ```bash
   VBoxManage --version
   ```

3. **Docker** (for container runtime):  
   📥 [Install Docker Engine](https://docs.docker.com/engine/install/)  
   *Verify installation:*  
   ```bash
   docker --version
   ```

4. **Docker Compose** (for stack deployment):  
   📥 [Install Docker Compose](https://docs.docker.com/compose/install/)  
   *Verify installation:*  
   ```bash
   docker compose version
   ```

5. **Git** (for version control):  
   📥 [Install Git](https://git-scm.com/downloads)  
   *Verify installation:*  
   ```bash
   git --version
   ```

---

## 📁 Project Structure

```

.
├── Vagrantfile                     # Defines leader, manager, and worker nodes
├── provisioning/                  # Shell scripts to provision each node type
│   ├── provision\_lnode.sh
│   ├── provision\_mnode.sh
│   └── provision\_wnode.sh
├── services/
│   ├── backend/                   # Node.js backend
│   │   └── backend.env.example
│   ├── database/
│   │   └── mysql.env.example
│   ├── frontend/
│   │   └── nginx/
│   │       ├── nginx.conf
│   │       └── error.html
│   ├── phpmyadmin/
│   │   └── phpmyadmin.env.example
│   ├── proxy/
│   │   ├── nginx.conf
│   │   └── error.html
│   └── redis/
│       └── redis.env.example
├── docker-stack.yml               # Swarm stack definition

````

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/mohamedfawzizaki/iac-vagrant-swarm-cluster.git
cd your-repo-name
````

### 2. Spin up Vagrant Swarm nodes

This brings up:

* 1 Leader node (`leader-node`)
* 1 Manager node (`mnode1`)
* 1 Worker node (`wnode1`)

```bash
vagrant up
```

Provisioning scripts will:

* Install Docker
* Initialize the Swarm on the leader
* Join other nodes with appropriate tokens

> Add or uncomment more nodes (`mnode2`, `wnode2`) in the `Vagrantfile` to scale.

---

## 🐋 Deploy the Docker Swarm Stack

SSH into the leader node:

```bash
vagrant ssh leader-node
cd /vagrant
docker stack deploy -c docker-stack.yaml webstack
```

Verify service status:

```bash
docker service ls
```

Access the services:
   - Frontend: http://192.168.65.10
   - phpMyAdmin: http://192.168.65.10:8080
---


## ⚙️ Services Overview

| Service        | Description                         | Port(s)         |
| -------------- | ----------------------------------- | --------------- |
| `frontend`     | React app behind Nginx              | 80, 443         |
| `base_backend` | Node.js backend API                 | 3000 (internal) |
| `proxy`        | External-facing Nginx reverse proxy | —               |
| `mysql-db`     | MySQL 8.0 database                  | internal only   |
| `phpmyadmin`   | DB admin panel                      | 8080            |
| `redis`        | Redis with password protection      | internal only   |

---

## 🧪 Healthchecks

* `proxy`: `curl http://localhost/health`
* `mysql`: `mysqladmin ping`
* `redis`: `redis-cli ping`

---

## 📦 Docker Swarm Features Used

* Multi-node overlay networks: `public-net`, `private-net`
* Docker Configs for dynamic Nginx configuration
* Environment files for sensitive variables
* Service placement constraints
* Self-healing via restart policies

---

## 🧹 Cleanup

To destroy the Vagrant environment:

```bash
vagrant destroy -f
```

To remove the Swarm stack:

```bash
docker stack rm webstack
```

## Cluster Architecture

### Virtual Machines
| Node Type     | Hostname    | IP Address    | vCPUs | Memory | Disk Size |
|--------------|------------|--------------|-------|--------|-----------|
| Leader       | leader-node| 192.168.65.10| 1     | 1GB    | 40GB      |
| Manager 1    | mnode1     | 192.168.65.11| 1     | 1GB    | 40GB      |
| Worker 1     | wnode1     | 192.168.65.13| 1     | 1GB    | 40GB      |

### Deployed Services
- Frontend: React app served via Nginx (port 80/443)
- Backend: Node.js service (port 3000)
- Database: MySQL 8.0 with phpMyAdmin (port 8080)
- Redis: Redis cache with persistence
- Proxy: Nginx reverse proxy with health checks

## Provisioning Scripts

Each node type has its own provisioning script:
- `provisioning/provision_lnode.sh`: Sets up the leader node and initializes the swarm
- `provisioning/provision_mnode.sh`: Joins manager nodes to the swarm
- `provisioning/provision_wnode.sh`: Joins worker nodes to the swarm

## Docker Stack Configuration

The stack is defined in the embedded docker-compose.yml file with:
- Overlay networks for public/private communication
- Configs for Nginx configurations
- Health checks for critical services
- Persistent volumes for Redis and MySQL
- Environment variables loaded from .env files

## Customization

To modify the cluster:
1. Edit the Vagrantfile to:
   - Change IP addresses
   - Add more manager/worker nodes (uncomment sections)
   - Adjust resource allocations

2. Edit the provisioning scripts to:
   - Change Docker versions
   - Add additional packages
   - Modify swarm parameters

3. Edit the docker-compose.yml to:
   - Change service configurations
   - Update image versions
   - Modify resource limits

## Maintenance

- To pause the cluster: `vagrant suspend`
- To restart the cluster: `vagrant reload`
- To destroy the cluster: `vagrant destroy`

## Troubleshooting

1. If provisioning fails:
   - Check VirtualBox VM logs
   - Run `vagrant provision` to retry provisioning
   - Verify your host machine meets the resource requirements

2. If services don't start:
   - SSH into nodes with `vagrant ssh <node-name>`
   - Check Docker logs: `docker service logs <service-name>`
   - Verify swarm status: `docker node ls`


## 📧 Contact

Mohamed Fawzi Zaki - mohamedfawzizaki@gmail.com

Project Link: [https://github.com/mohamedfawzizaki/iac-vagrant-swarm-cluster]
---
