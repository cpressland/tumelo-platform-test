# Refactoring everyday

Hello there, I need your help with a little terraform project I'm doing to manage DNS in AWS.

In the src directory there are two different terraform workspaces, one for a staging environment and one for production, these workspaces are in charge of configuring a DNS zone in the AWS Route53 service and creating different records for the zone.

As can be seen, the code for both environments is quite similar, with duplicate code existing between the two workspaces, so that if we now want to create a new environment we would have to copy and paste exactly the same code for a new workspace.

We want to follow the DRY principle and make the configuration simpler, so that if we also need a new record for all environments it is easier for us and we don't have to duplicate a lot of code.

You can use `terraform validate` command to ensure the configuration is valid for the workspaces and the module after refactoring.

_Note: There is no single correct solution, multiple different solutions can be considered equally valid but the aim is to see your experience with terraform._
