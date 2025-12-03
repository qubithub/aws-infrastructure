# QInterpreter Designer AWS Infrastructure

## Summary
This repository includes infrastructure as code definitions to launch common functionality for web apps composing the QInterpreter-Designer knowledge gateway. 

The QInterpreter-Designer as a full-stack web application consisting of a UI written in Next.JS and APIs written in python. The application allows users to define quantum circuits using a visual builder and select a quantum simulator or hardware on which to run their circuit. Auth is provided to honor licensing agreements with quantum service providers. 

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

| Product       | Description |
| ------------- | ----------- | 
| Cognito | AWS Hosted user authentication service. Registered users sign into qinterpreter-designer through Cognito which grants a cryptographically signed JSON Web Token (jwt). The JWT acts as a key that the user can use to unlock server resources. | 
| Cognito Groups | Users will be assigned to groups which will be used by the API gateway to determine the level of access the user has to resources. |
| DNS (Route 53) | Describes how named resources (qubithub.org) should be translated to IP addresses. Our DNS configurations describe a hosted zone, which is a subset of the qubithub.org domain. | 
| Certificate Manager | For websites to be served over https we must provide a cryptographically signed certificate showing we own the domain. Certificate manager provides this certificate and verifies ownership in combination with entries made automatically in Route 53. 
| Content Distribution Network (Cloudfront) | Caches static web resources at edge nodes on the internet. Reduces hosting costs be taking load off of servers for generating static content. Speeds page performance by physically locating data closer to the user. |
| Object Storage (S3) | Stores files as binary blobs. Used to store current cloud object configurations (terraform remote backend) and to host static files for the UI. | 
| API Gateway | Allows for definition of resources available in the application. The gateway will be configured to verify the JWTs attached to incoming requests and allow / deny access to compute based on the user's assigned cognito group. 
| Serverless Code Execution (Lambda) | Scripts that can be run based on triggering events. Typically charged per instantiation. An alternative to renting servers by the hour. | 
| Serverless Code Execution (Fargate) | Images that can be run and scaled based on triggering events. An alternative to renting servers by the hour. | 
| Container Registry (ECR) | Archives software images. Changes made to QInterpreter APIs will be built as a Docker Image and stored in the container registry. The serverless runtime will pull the latest image and run it when it is invoked. Major releases can be assigned a DOI. |

## Hosting Strategy
Network Diagram
Sequence Diagram

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