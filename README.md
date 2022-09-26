---
title: Using Steampipe with BuildKite CI/CD Pipeline
sidebar_label: BuildKite CI/CD
---

# Using Steampipe with BuildKite CI/CD Pipeline

[Buildkite](https://buildkite.com/) is a platform for running continuous integration on your own infrastructure with the help of pipeline commands. Installing Steampipe and using the [Terraform](https://hub.steampipe.io/plugins/turbot/terraform) plugin we can query Terraform files, and leveraging Steampipe mod packs, can detect security misconfigurations and report it.
Buildkite also gives you a 30 day free trial to build and run pipelines.

Here we will see a sample to integrate Steampipe to the Buildkite pipeline that can scan resources for compliance and send a snapshot to the Steampipe cloud dashboard.

## About this solution

This sample integration consists of a Buildkite pipeline file with the commands on how to install Steampipe and it's terraform plugin, run Steampipe to push the snapshot to Steampipe Cloud for review. The Pipeline will pull the terraform files from GitHub and execute Steampipe in a Buildkite pipeline and publish the findings If there are issues.

To note here:
You need to create a Buildkite organization with a pipeline that is [connected to your github account](https://buildkite.com/docs/integrations/github) with access keys configured with a [Buildkite agent](https://buildkite.com/docs/agent/v3) running.


## Running Steampipe in a BuildKite Pipeline

Running Steampipe in a Buildkite pipeline is pretty simple. By default it executes the build as root, however for security reasons, Steampipe will only run as a regular user. With the Buildkite pipeline capability, you can specify commands run by a different user.

The pipeline.yml file for running Steampipe looks like this:

```
steps:
  - commands:
      # Installs Steampipe
    - "curl -s -L https://github.com/turbot/steampipe/releases/download/v0.17.0-alpha.16/steampipe_linux_amd64.tar.gz | tar -xzf -"

    - "echo installed steampipe"

      #Place the .steampipe install in the local directory for this build
    - "export STEAMPIPE_INSTALL_DIR=`pwd`/.steampipe"

    - "git clone https://github.com/turbot/steampipe-mod-terraform-aws-compliance.git"

    - "su buildkite -c './steampipe plugin install terraform'"

    - "su buildkite -c 'cd terraform ; export STATUS_URL=`STEAMPIPE_WORKSPACE_CHDIR=/home/buildkite/steampipe-mod-terraform-aws-compliance /home/buildkite/steampipe dashboard benchmark.s3 --share=rahulsrivastav14/integrated2022 --cloud-host latestpipe.turbot.io --cloud-token spt_cclfillo4h69eos3reug_1jc3lxemyt163500nqbsvsby0`'"
    ```


This, installs steampipe and the terraform-aws-compliance mod. Then it will initialize steampipe, download the terraform plugin, and run the Terraform S3 Benchmark. The snapshot of the scan is then uploaded to Steampipe Cloud to the Workspace.

The dashboard would look like this on your Steampipe cloud:

<Screenshot of the dashboard>