Implementation of a multi stage CI-CD pipeline using YAML and Terraform

Scope: 

A basic ASP.NET web application was created using Visual Studio - Julapp

Terraform was used to provision our infrastructure on azure: App service, Application gateway with Web Application Firewall (WAF) enabled - main.tf, appservice.tf, appgw&waf.tf, variables.tf

Below document explains the set up between App service and application gateway

Link: https://learn.microsoft.com/en-us/azure/application-gateway/configure-web-app?tabs=defaultdomain%2Cazure-portal
 



Application gateway with WAF enabled provides L7 security for our app service by making use of Core Rule Set (CRS) from the Open Web Application Security Project (OWASP).
 
YAML pipeline (azure-pipelines.yml) was created for 2 reasons:
-	Deploy our infrastructure to azure using terraform
-	Implement a build and release for our application then deploy the artifact to our App service
 

Template files called tfvalidate-template.yml, tfdeploy-azure-template.yml and tfdeploy-appservice-template.yml was implemented to improve readability and reusability of our code.

A service principal was created in Azure AD to authenticate between Azure DevOps organization and Azure portal through a service connection.

A YAML pipeline(tfdestroy-pipeline.yml) to destroy to our infrastructure whenever we need to was created.