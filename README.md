# Revolut Challenge
![Diagram](challenge-diagram.png)
**This Repository contains:
- Infrastructure code in Terraform deploying the architecture at AWS
- K8s deployment files
- Python app exposing a rest API and using PostgreSQL as database

**PreReqs:
- AWS account
- AWS service account with admin access
- Terraform installed, version 0.12.*
- AWS CLI installed
- Kubectl installed 

**How TO:
1. Clone the repository locally
```git clone https://github.com/gealmei/_revolut-challenge.git```
2. With AWS credentials configured go to directory infrastructure and execute
```terraform apply -auto-approve```
or fist you can validate the actions with
```terraform plan```
3. After 

curl -X PUT -H "Content-type: application/json" http://localhost:8000/hello/guilherme -d '{"dateOfBirthday":"1987-09-23"}'
