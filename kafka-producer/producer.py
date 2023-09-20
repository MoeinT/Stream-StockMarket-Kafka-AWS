import csv
import json
import time
from confluent_kafka import Producer
import configparser

class KafkaStockMarket:
    def __init__(self, bootstrap_servers, csv_file_path, key=None):
        self.producer_config = {
            "bootstrap.servers": bootstrap_servers,
        }
        self.producer = Producer(self.producer_config)
        self.csv_file_path = csv_file_path
        self.key = key

    def produce_to_kafka(self, topic_name):
        with open(self.csv_file_path, newline="") as csvfile:
            csv_reader = csv.reader(csvfile)
            # Skip the header row if it exists
            next(csv_reader, None)
            # Iterate through each row in the CSV file
            for row in csv_reader:
                try:
                    record = {
                        "symbol": row[0],
                        "date": row[1],
                        "open": row[2],
                        "high": row[3],
                        "low": row[4],
                        "close": row[5],
                        "adj_close": row[6],
                        "volume": row[7],
                    }
                    self.producer.produce(topic_name, key=self.key, value=json.dumps(record))
                    self.producer.flush()  # Flush to ensure the message is sent immediately
                    print("A message sent!")
                except Exception as e:
                    print(f"An error occurred while sending a message: {e}")
                # Wait for 10 seconds before sending the next message
                time.sleep(2)

if __name__ == "__main__":
    # Read the config file
    config = configparser.ConfigParser()
    config.read("../config.ini")
    bootstrap_server = config["stock"]["bootstrap_server"]
    csv_file_path = "../data/indexProcessed.csv"
    topic_name = config["stock"]["topic_name"] 

    producer_instance = KafkaStockMarket(bootstrap_server, csv_file_path)
    producer_instance.produce_to_kafka(topic_name)
