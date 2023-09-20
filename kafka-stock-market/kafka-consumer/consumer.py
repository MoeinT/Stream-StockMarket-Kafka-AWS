from confluent_kafka import Consumer, KafkaError
import boto3
import csv
import json
import time
import os
import configparser

class KafkaToS3Consumer:
    def __init__(self, bootstrap_servers, group_id, topic_name, s3_bucket_name, s3_prefix):
        self.consumer_config = {
            "bootstrap.servers": bootstrap_servers,
            "group.id": group_id,
            "auto.offset.reset": "earliest"
        }
        self.consumer = Consumer(self.consumer_config)
        self.topic_name = topic_name
        self.s3_bucket_name = s3_bucket_name
        self.s3_prefix = s3_prefix
        self.s3_client = boto3.client('s3', verify=False)

    def consume_and_send_to_s3(self):
        self.consumer.subscribe([self.topic_name])
        while True:
            msg = self.consumer.poll(1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    continue
                else:
                    print("Error: %s" % msg.error())
            else:
                try:
                    record = json.loads(msg.value())
                    key = f"{self.s3_prefix}/{record['date']}.json"
                    # Upload the JSON data to S3 as a file
                    self.s3_client.put_object(Bucket=self.s3_bucket_name, Key=key, Body=json.dumps(record))
                    print(f"Sent message to S3: {key}")
                    time.sleep(2)
                except Exception as e:
                    print(f"An error occurred while processing a message: {e}")

if __name__ == "__main__":
    # Read the config file
    config = configparser.ConfigParser()
    config.read("../config.ini")
    # Get the Kafka credentials
    bootstrap_server = config["stock"]["bootstrap_server"] 
    group_id = config["stock"]["group_id"] 
    topic_name = config["stock"]["topic_name"] 
    s3_bucket_name = config["stock"]["s3_bucket_name"] 
    s3_prefix = config["stock"]["s3_prefix"] 
    # Set environment variables for boto3 to read dynamically
    os.environ["AWS_ACCESS_KEY_ID"] = config["stock"]["AWS_ACCESS_KEY_ID"]
    os.environ["AWS_SECRET_ACCESS_KEY"] = config["stock"]["AWS_SECRET_ACCESS_KEY"]
    os.environ["AWS_DEFAULT_REGION"] = config["stock"]["AWS_DEFAULT_REGION"]

    # Instantiate the class and start consuming
    consumer_instance = KafkaToS3Consumer(bootstrap_server, group_id, topic_name, s3_bucket_name, s3_prefix)
    consumer_instance.consume_and_send_to_s3()