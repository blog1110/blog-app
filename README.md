# Blog Application Deployment on EKS using Helm and GitHub Actions

This repository is used to deploy a **Blog application** developed in **Go** on a **Kubernetes cluster** hosted on **Amazon EKS**. The deployment is managed using **Helm charts** and **GitHub Actions workflows**.

---

## 📦 Repository Structure

### Charts
This directory contains Helm charts used for deploying the application and kubernetes infrastructure components.

- **`application/`**
  Contains:
  - `blog/`: Helm chart for deploying the Go-based blog application.
  - `postgres/`: Helm chart for installing the PostgreSQL database used by the blog app.

- **`kubernetes/`**  
  Contains:
  - Helm chart responsible for creating required Kubernetes namespaces in the target environments (`dev`, `prod`, etc.).

---

## 🚀 Deployment Workflows

There are **two main GitHub Actions workflows** defined in this repository:

### 1. **Blog Application Deployment (`blog_app_deployment`)**

Handles the deployment of the blog application and its dependencies (Postgres DB) to the EKS cluster.

#### Trigger Modes:
- **Automatic Deployment (Dev)**:  
  Triggered on `push` to the `main` branch. Automatically deploys to the **`dev` environment**.
  
- **Manual Deployment (Prod)**:  
  Triggered via `workflow_dispatch`. Requires manual input for:
  - `commitsha`: Git commit hash to be deployed
  - `environment`: Choose between `dev` and `prod`

```yaml
on:
  push:
    branches:
      - main
  workflow_dispatch:
    inputs:
      commitsha:
        description: Commit Hash to be used in build and deployment
      environment:
        description: 'Environment:'
        type: choice
        required: true
        default: 'dev'
        options:
          - dev
          - prod
