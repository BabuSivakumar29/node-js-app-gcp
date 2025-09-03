# REST API with MySQL Backend

This project is a **REST API application** built from scratch with a **MySQL backend**. The application exposes two endpoints:

- `/` (Root Path): Displays a welcome message.
- `/users`: Retrieves data from the `users` table in Cloud SQL MySQL, populated via migrations and seed data.

The **infrastructure and application provisioning** is fully automated using **CI/CD pipelines**.

---

## Pre-requisites

Before deploying this project, ensure you have the following:

1. **GCP Account** and project.
2. **GCloud CLI** installed.
3. **Terraform** installed.
4. **GitHub Account**.
5. **Git Personal Access Token (PAT)** with permissions:
   - Pull & Push
   - Artifact read & write access

---

## Installing GCloud in WSL

Run the following commands to install GCloud SDK on **WSL (Ubuntu/Debian)**:

```bash
# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates gnupg

# Add GCP repository
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
  | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Add GCP public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Install Google Cloud SDK
sudo apt-get update && sudo apt-get install -y google-cloud-sdk

# Login to GCP
gcloud auth login
gcloud config set project <PROJECT_ID>

---

## Deployment Steps

### 1. Configure Service Account and OIDC
- Replace all variables in the `initial_setup.sh` script.
- Run the script to create a service account and configure **OIDC with Workload Identity Federation**.

### 2. Set GitHub Secrets
Create the following secrets in your repository:

```text
GCP_PROJECT=<PROJECT_ID>
GCP_SA_EMAIL=<service_account_email_created_in_previous_step>
WORKLOAD_IDENTITY_PROVIDER=<gcloud iam workload-identity-pools describe "$WID_POOL_NAME" \
  --location="global" --format="value(name)">
---

## CI/CD Pipeline Overview

### Continuous Integration (CI) Stage

The CI pipeline ensures **code quality, security, and readiness** before deployment. Key steps include:

1. **Build Application**
   - Compile or package the application (e.g., Node.js build).
   - Run unit tests to validate application logic.

2. **Code Quality & Security Checks**
   - Lint application code for consistent style.
   - Run vulnerability checks and static code analysis.
   - Scan Docker images for known vulnerabilities.

3. **Terraform Pre-Checks**
   - Run `terraform fmt` to standardize code formatting.
   - Run `terraform validate` to check for configuration issues.
   - Execute `terraform plan` to preview infrastructure changes.

---

### Continuous Deployment (CD) Stage

The CD pipeline provisions infrastructure, deploys the application, and ensures a smooth release process. Key steps include:

1. **Provision Infrastructure**
   - Apply Terraform configurations to provision necessary GCP resources (VPC, Cloud SQL, Cloud Run, IAM, etc.).

2. **Build & Push Docker Image**
   - Build Docker images of the REST API application.
   - Push Docker images to **Google Container Registry (GCR)**.

3. **Deploy Application**
   - Deploy the application to **Cloud Run** using the updated Docker image.
   - Configure environment variables and secrets from **Secret Manager** (e.g., database credentials).

---

## Assumptions Made

The following assumptions were made while designing and deploying this REST API project:

### Cloud Environment
- A valid **GCP account** and project exist.
- The user has sufficient **permissions** to create service accounts, Cloud SQL instances, Cloud Run services, and other required resources.
- Required **GCP APIs** (Cloud SQL, IAM, Cloud Run, Artifact Registry) are already enabled.

### Infrastructure
- **Terraform** and **gcloud CLI** are installed and correctly configured.
- Network connectivity is available for deployment and API communication.
- Terraform state management (remote backend or local) is properly set up for tracking infrastructure.

### Application
- The **Node.js version** is compatible with the application code.
- Database schema matches the migrations and seed scripts provided.
- Required **environment variables and secrets** are correctly configured via Secret Manager.

### CI/CD
- GitHub repository exists and **Git PAT token** has the required permissions (pull, push, artifact read/write).
- GitHub Actions runners have access to all required tools (Terraform, Docker, Node.js).
- **OIDC Workload Identity Federation** is correctly configured for secure authentication.

### Security
- Secrets are stored securely in **GCP Secret Manager** and are not exposed in logs or code.
- Access to the deployed endpoints assumes proper authentication/authorization is in place (if enabled).

These assumptions define the **expected environment and conditions** under which the application and infrastructure are designed to work successfully.

---

## Security Measures Taken

The following security measures have been implemented to ensure a secure deployment of the REST API application:

### Secrets Management
- All sensitive data, including **database credentials**, API keys, and environment variables, are stored securely in **GCP Secret Manager**.
- Secrets are never hard-coded in the application or Terraform configurations.
- Access to secrets is restricted to only the service accounts that require them.

### Identity & Access Management
- **Workload Identity Federation (OIDC)** is used to allow GitHub Actions to authenticate securely with GCP without storing long-lived service account keys.
- Principle of **least privilege** is applied to all service accounts:
  - Only required roles/permissions are granted for infrastructure provisioning and application deployment.
- IAM policies are explicitly defined in Terraform to maintain auditable and reproducible access control.

### Infrastructure Security
- **Cloud SQL instances** are deployed with private IPs and optional SSL/TLS connections.
- **Cloud Run services** are deployed with appropriate IAM permissions and network settings to prevent unauthorized access.
- Firewall rules and VPC configurations restrict access to only trusted sources where applicable.

### CI/CD Security
- GitHub PAT tokens are stored securely as **GitHub secrets** and not exposed in workflow logs.
- CI/CD pipelines include **static code analysis and vulnerability scanning** for both application code and Docker images.
- Terraform plans are reviewed automatically in CI before applying to prevent accidental misconfigurations.

### Monitoring & Alerts
- Application and infrastructure logs are monitored for unusual activity.
- Alerts can be configured in GCP Monitoring to notify administrators of failures or security events.

These measures ensure that the deployment is **secure, auditable, and compliant** with best practices for cloud-native applications.

---

## Explanation of Alerting Setup

To ensure the application and infrastructure run smoothly, basic alerting has been set up:

- **Monitoring & Logging:** Cloud Monitoring tracks metrics for Cloud Run and Cloud SQL. Cloud Logging captures application and database logs.
- **Alert Policies:**
  - Cloud Run CPU and Memory alert
  - Error count based alert
- **Notifications:** Alerts are sent via email or messaging channels (Slack/Google Chat).

This setup helps detect problems early and ensures quick response to keep the application running reliably.

### Note:
- All screenshot images, including deployment results, CI/CD pipeline runs, and application outputs, are stored in the `evidences` directory for reference.
