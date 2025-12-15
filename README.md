# Test task for middle devops role

- backend deployes to ec2 instance in user-data, written mock backend server, that tests database connection
- frontend should be manualy uploaded to created S3 bucket so CloudFront can distribute it once static is there.
