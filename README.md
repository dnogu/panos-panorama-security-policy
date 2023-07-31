# Palo Alto Networks Terraform Configuration

This repository contains a Terraform configuration that leverages the PAN-OS provider for Terraform to manage the configuration of a Palo Alto Networks firewall or Panorama device. The configuration allows the creation and management of IP address objects, Fully Qualified Domain Name (FQDN) objects, Service objects, and Security Rule Groups.

## Resources

This configuration manages the following resources:

1. **IP Address Objects**: These are the IP addresses that will be associated with your Palo Alto device.
2. **FQDN Objects**: These are the fully qualified domain names associated with your application. FQDN objects allow you to create policy based on the domain names that your users access.
3. **Service Objects**: These are the services (protocol and port) associated with your application.
4. **Security Rule Groups**: This configuration dynamically creates security rules based on the rule map provided in the variables.

## Files

This repository includes the following files:

1. `main.tf`: This file contains the resources managed by this configuration.
2. `locals.tf`: This file contains local values that are used to process and format the rule data provided in the variables.
3. `variables.tf`: This file contains the variable definitions that the user should provide to this Terraform configuration. This includes the rules to be applied and the device group in Palo Alto for the rules to be applied.
4. `example.tfvars`: This is an example variables file with the format you should follow when providing your rule definitions and the name of your device group.

## Usage

Follow these steps to use this configuration:

1. Clone this repository to your local system.
2. Navigate to the directory containing the configuration files in a terminal or command prompt.
3. Update your variables file with your rules and device group.
4. Initialize your Terraform workspace, which will download the provider and initialize it with the provided credentials.

```
terraform init
```

5. Plan the deployment. This step allows Terraform to create an execution plan reflecting the changes that will be made to your resources.

```
terraform plan -out=tfplan -var-file=example.tfvars
```

6. Apply the deployment plan. This step will create the resources in your Palo Alto device or Panorama as per the plan. Be sure to review the plan before applying it.

```
terraform apply "tfplan"
```

> **Note:** Please ensure you have the necessary permissions and network access to manage resources in your Palo Alto device or Panorama.
