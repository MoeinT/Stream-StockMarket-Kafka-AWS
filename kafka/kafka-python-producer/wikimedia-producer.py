import requests
import time

stream_url = "https://stream.wikimedia.org/v2/stream/recentchange"

response = requests.get(stream_url, stream=True)

for line in response.iter_lines(decode_unicode=True):
    if line:
        # Process and handle each event as needed
        print(line)
        time.sleep(5)