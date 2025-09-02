#!/bin/bash

# Variables
PROJECT_ID="intense-elysium-470611-j0"
PROJECT_NUMBER="377335099304"
ROLE_ID="terraform_backend_role"
ROLE_TITLE="Terraform Backend Role"
ROLE_DESCRIPTION="Custom role for Terraform backend access to GCS"
MEMBER="user:babumallow02@gmail.com"
BUCKET_NAME="nodejs_tf_backend"
WID_POOL_NAME="node-js-app"
GITHUB_ORG="Bsivakumar29"
GITHUB_REPO="node-js-app-gcp"


# Create the custom role
gcloud iam roles create $ROLE_ID \
  --project $PROJECT_ID \
  --title "$ROLE_TITLE" \
  --description "$ROLE_DESCRIPTION" \
  --permissions storage.objects.get,storage.objects.list,storage.objects.create,storage.objects.delete,storage.objects.update,storage.buckets.get \
  --stage GA

# Assign the role to your user or service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="$MEMBER" \
  --role="projects/$PROJECT_ID/roles/$ROLE_ID"

echo "Custom Terraform backend role created and assigned successfully!"

# Creating Bucket as state file backend storage
gsutil mb -p $PROJECT_ID -l us-east1 gs://$BUCKET_NAME/
gsutil versioning set on gs://$BUCKET_NAME

# Enable IAM & IAM Credentials API
gcloud services enable iam.googleapis.com iamcredentials.googleapis.com

# Create Workload Identity Pool
gcloud iam workload-identity-pools create "$WID_POOL_NAME" \
  --location="global" \
  --display-name="GitHub Actions Pool"

# Describe Workload Identity Pool
gcloud iam workload-identity-pools describe "$WID_POOL_NAME" \
  --location="global" \
  --format="value(name)"

gcloud iam workload-identity-pools providers create-oidc "$GITHUB_REPO-provider" \
  --workload-identity-pool="$WID_POOL_NAME" \
  --location="global" \
  --display-name="GitHub Provider" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.owner=assertion.repository_owner" \
  --attribute-condition="attribute.repository=='$GITHUB_ORG/$GITHUB_REPO'"

# Create Service Account
gcloud iam service-accounts create github-deployer \
  --display-name="GitHub Deployer"

# Assign roles to Service Account
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-deployer@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin" \
  --role="roles/artifactregistry.writer" \
  --role="roles/secretmanager.secretAccessor" \
  --role="roles/cloudsql.client" \
  --role="roles/serviceusage.serviceUsageViewer" \
  --role="roles/storage.objectAdmin" \
  --role="roles/storage.objectViewer"

# Bind GitHub Repo to GCP Service Account
gcloud iam service-accounts add-iam-policy-binding \
  github-deployer@$PROJECT_ID.iam.gserviceaccount.com \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$WID_POOL_NAME/attribute.repository/$GITHUB_ORG/$GITHUB_REPO"
