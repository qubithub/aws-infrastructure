# Qubithub AWS Infrastructure

## Summary
This repository includes infrastructure as code definitions to launch common functionality for web apps composing the qubithub knowledge gateway. 

The infrastructure as code definitions are provided in [terraform](https://developer.hashicorp.com/terraform). Terraform is a configuration language for describing cloud objects and their relations with one another. 

Additionally, deployments to AWS are automated using [github actions](https://docs.github.com/en/actions). When a pull request has been successfully merged to the main branch the infrastructure change will be automatically deployed to the staging and production environments. 

AWS Resources are deployed to the `mx-central-1` region. 

## Strategy
### Accounts
The Qubithub account structure is as follows: 
| Account Name | Account Number | Description |
| ------------ | -------------- | ----------- |
| Admin | 985602287934 | Responsible for cost reporting and the identity center | 
| Production | 470892538034 | The live environment for qubithub users |
| Staging | 806985512920 | An environment for testing features before public release |

### Identity and Access Management
**User**
Contact a project administrator if you would like to be added as a console level user. 
Users are created in the IAM Identity Center and assigned to a group. 
**Groups**
Describe pools of users with common permissions (policies) available. 
**Role**
So far there are two roles, which users adopt before they take actions. Admin and TerraformRunner. 
**Credentials**
The project uses short-lived aws credentials through the STS. 

### Infrastructure
Planned common infrastructure. 
* API Gateway
* Cognito (Identity Provider for Login)
* DNS

## Contributing
### Suggested Software
* [AWS CLI](https://aws.amazon.com/cli/) 2.31 or above
* [Terraform CLI](https://developer.hashicorp.com/terraform/install)  1.13.5 or above

### Branch Strategy
The project follows trunk-based development where the state of the main branch of the repo is the state of the deployed cloud objects. 

Developers proposing changes should create a branch from main with the following naming convention: 
* `/feature/short-description-of-feature` for new functionality
* `/bugfix/short-description-of-fix` for fixing mistakes

Changes can only be applied to main through a pull request. One project owner must approve the pull request before it will be merged. Once merged the change will automatically apply first to the staging environment and then production environment. 

## Authors
* [George Dill](https://github.com/kimjongdill) - [Avondalien Software](https://www.avondalien.com)