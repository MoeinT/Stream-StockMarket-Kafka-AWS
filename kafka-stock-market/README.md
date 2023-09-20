# Building a Kafka Data Pipeline with AWS Integration
In this tutorial, we will walk through the process of setting up a data pipeline to process stock market information from a CSV file. We will stream the data through Apache Kafka and store it in AWS S3 for further analysis. This tutorial will showcase key skills in Apache Kafka, Python, Terraform, and CI/CD with GitHub Actions.

Prerequisites
Before you begin, ensure that you have the following prerequisites in place:

- Docker installed on your local machine to set up a Kafka environment.
- Python installed on your local machine.
- An AWS account with access keys and appropriate permissions.

## Project Architecture
Below is the project architecture. Here's an overview of the architecture: 

- 1: A kafka cluster is up & running using Docker Compose
- 2: Source data from a CSV file is read and sent to a Kafka topic 
- 3: The messages are further consumed with Python and sent to an AWS S3
- 4: Created an AWS crawler on top of the raw Json files inside AWS S3
- 5: Ran a Glue Catalog and integrated the Raw data into AWS Glue and analyzed it using AWS Athena and SQL

<p align="center">
  <img width="500" height="300" src=./assets/ArchitectureStockMarket.PNG>
</p>

## Step 1: Source Data
Since we do not have access to the Stock Market API to ingest messages on a real time basis, we have used a CSV file and sent each row as an event to a Kafka topic. This csv file is found under the ```./data``` directory.

## Step 2: Set Up Kafka Environment
We used Docker Compose to pull the Zookeeper and Kafka images and run them as Docker Containers. We've used [this](https://github.com/conduktor/kafka-stack-docker-compose/blob/master/full-stack.yml) configuration file; once the cluster is up & running, we'll interact with it using Python from our local machine. 
```
docker-compose up -d
```

## Step 3: Create a Kafka Topic
Once the cluster is up & running, we will go inside the container using the below command: 
```
docker exec -it <container_name> sh
```
Using the Kafka CLI, we create a Kafka topic with 3 partitions and a replication factor of 1. This command ensures the topic is created if it doesn't already exist.
```
kafka-topics --create --topic <topic_name> --partitions 3 --replication-factor 1 --if-not-exists --bootstrap-server <server_name>
```

## Step 4: Develop the Producer Module
Create a Python producer module to send each record in the CSV file as a JSON message into the Kafka topic. You can use the confluent_kafka package for Kafka integration. Additionally, we have used poetry as our virtual environment to manage the dependencies. Find this module under the ```./kafka-producer``` directory.

## Step 5: Develop the Consumer Module
Create a Python consumer module to consume messages from the Kafka topic. Send each message to an AWS S3 bucket programmatically using the boto3 package. Find this module under the ```./kafka-consumer``` directory.

## Step 6: AWS Integration
On AWS, use Terraform to provision the necessary resources:

- Created an S3 bucket for storing raw data with server-side encryption configured.
- Set up AWS Glue Crawlers to crawl the S3 bucket containing the raw data.
- Define an IAM role with the "AmazonS3FullAccess" and "AWSGlueServiceRole" policies to allow interaction with the S3 bucket.

We also established a CI/CD pipeline using GitHub Actions and Terraform, storeed the tfstate file in an S3 bucket for remote backend management.

## Conclusion
This project demonstrates the complete process of setting up a Kafka data pipeline with AWS integration. It showcases the use of Apache Kafka, Python programming, Terraform infrastructure as code, and CI/CD automation with GitHub Actions. By following these steps, you can efficiently process and analyze stock market data using a robust and scalable data pipeline.

## Contact 
- moin.torabi@gmail.com
- [LinkedIn](https://www.linkedin.com/in/moeintorabi/)
