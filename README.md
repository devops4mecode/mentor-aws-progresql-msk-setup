### How to setup Terraform for AWS ProgreSQL and MSK

STEP 1:
Define your Terraform code to create a PostgreSQL database instance using the AWS RDS module, and define a security group for the database that allows traffic from the MSK connector. Please refer postgresql.tf file.

STEP 2:
Create an AWS MSK cluster and a Kafka topic, and then create a Kafka Connect connector to connect to the PostgreSQL database using the Debezium connector. This will automatically produce audit logs to the Kafka topic whenever changes occur in the database. Please refer to aws_msk_cluster.tf file

STEP 3:
Go to AWS Console reate a CloudWatch log group and a log stream to receive the audit logs from the Kafka topic. You can then use the AWS Lambda function or Amazon Kinesis Data Analytics.