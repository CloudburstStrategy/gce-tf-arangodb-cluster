Terraform an ArangoDB Cluster in Google Compute Engine
======================================================

Terraform configuration for building an ArangoDB Cluster in Google Compute

See https://github.com/arangodb-helper/arangodb#running-in-docker for more info

This terraform configuration will create a 3 host cluster with a single host in each of zones a,b & c in the required region. 
Some regions don't have zone a so that might cause a failure, simply switch hosta to be in zone d :-).

### Prereqs

You need to [install Terraform](https://www.terraform.io/intro/getting-started/install.html)

You need to add an env var like:

    GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/application_default_credentials.json

Initialise Terraform from this directory:

    terraform init

### Add your own variables file

Copy example.tfvars to cluster.tfvars and update as appropriate:

    gce_project = "my-google-project"
    gce_region = "europe-west1"
    cluster_name = "mycluster"
    arangodb_password = "changeme"


# Terraform Commands

Check out what's going to happen with:

    terraform plan -var-file cluster.tfvars


Create the cluster with:

    terraform apply -var-file cluster.tfvars
    
    
Destroy the cluster with:

    terraform destroy -var-file cluster.tfvars