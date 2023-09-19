import csv
import json
import time

from confluent_kafka import Producer

# Producer configuration
producer_config = {
    "bootstrap.servers": "127.0.0.1:9092",  # Change to the appropriate broker(s)
}

producer = Producer(producer_config)

# Open and read the CSV file
with open("../data/indexProcessed.csv", newline="") as csvfile:
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
            producer.produce("my-topic", key="key", value=json.dumps(record))
            producer.flush()  # Flush to ensure the message is sent immediately
            print("A message sent!")
        except Exception as e:
            print(f"An error occurred while sending a message: {e}")

        # Wait for 10 seconds before sending the next message
        time.sleep(10)
