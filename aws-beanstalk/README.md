# AWS Elastic Beanstalk 

> AWS Elastic Beanstalk is an easy-to-use service for deploying and scaling web applications and services developed with Java, .NET, PHP, Node.js, Python, Ruby, Go, and Docker on familiar servers such as Apache, Nginx, Passenger, and IIS.

> You can simply upload your code and Elastic Beanstalk automatically handles the deployment, from capacity provisioning, load balancing, auto-scaling to application health monitoring. At the same time, you retain full control over the AWS resources powering your application and can access the underlying resources at any time.

[Amazon Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/)

## Network Diagram

![Network Diagram](aws-beanstalk.png)

## Resources (Managed by Elastic Beanstalk)

**Identity Access Management (IAM) Role**

aws-elasticbeanstalk-service-role

aws-elasticbeanstalk-ec2-role

**Simple Storage Service (S3) Bucket**

elasticbeanstalk-us-east-1-143287522423

**Elastic IP**

**Security Group (SG) Inbound**

| Type  | Protocol | Port Range | Source    |
| ----- | -------- | ---------- | --------- |
| HTTP  | TCP      | 80         | 0.0.0.0/0 |

**Security Group (SG) Outbound**

| Type  | Protocol | Port Range | Destination |
| ----- | -------- | ---------- | ----------- |
| ALL   | ALL      | ALL        | 0.0.0.0/0   |

**Elastic Cloud Compute (EC2)**

## Code (Python 3.6.8)

Steps to create *code.zip* to upload to Elastic Beanstalk.

1. Initialize pipenv: `pipenv --python 3.6.8`

2. Install Flask: `pipenv install Flask`

3. Create *application.py*; Elastic Beanstalk expects variable *application*, not *app*

4. Run locally: `export FLASK_APP=application.py`

5. Run locally: `pipenv run flask run`

6. Create *requirements.txt* file: `pipenv run pip freeze > requirements.txt`

7. Create *code.zip*: `zip code requirements.txt application.py`
