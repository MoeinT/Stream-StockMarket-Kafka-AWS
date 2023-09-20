import configparser
import json

import time
import pytz
import tweepy
import urllib.parse

class MyStream(tweepy.StreamingClient):
    def __init__(self, bearer_token, **kwargs):
        super(MyStream, self).__init__(bearer_token, **kwargs)

    def on_connect(self):
        print("Connected")

    # Retrieve the tweets
    def on_tweet(self, tweet):
        my_tweet = json.dumps(
            {
                "user_id": tweet.author_id,
                "created_at": tweet.created_at.astimezone(pytz.timezone("Europe/Paris")).strftime("%Y-%m-%d %H:%M:%S"),
                "tweet_type": MyStream.get_tweet_type(tweet.referenced_tweets),
                "lang": tweet.lang,
                "tweet": tweet.text,
                "hashtags": MyStream.get_hashtags(tweet.entities),
            },
            default=str,
        )

        print(f"A tweet has been received:\n {my_tweet}")
        time.sleep(5)

    @staticmethod
    def get_hashtags(entities: dict) -> str:
        if "hashtags" in entities.keys():
            l_tags = []
            for hashtag in entities["hashtags"]:
                if "tag" in hashtag.keys():
                    l_tags.append(hashtag["tag"])
            return ", ".join(l_tags)
        else:
            return ""

    @staticmethod
    def get_tweet_type(referenced_tweets: list[dict]) -> str:
        l_types = []
        if referenced_tweets != None:
            for item in referenced_tweets:
                if "type" in item.keys():
                    l_types.append(item["type"])
                else:
                    return ""
            return ", ".join(l_types)
        else:
            return "tweeted"


if __name__ == "__main__":

    # Initial config
    config = configparser.ConfigParser(interpolation=None)
    config.read("../config.ini")
    # bearer_token = urllib.parse.unquote(config["stock"]["bearer_token"])
    bearer_token = config["stock"]["bearer_token"]
    # Search terms
    search_terms = [
        "(Spark OR Kafka OR Python OR #DataEngineering OR #Airflow OR #Databricks OR #Databricks)"
    ]

    # Define a stream object
    stream = MyStream(
        bearer_token=bearer_token
    )

    # Add rules to the stream
    for term in search_terms:
        stream.add_rules(tweepy.StreamRule(term))

    # Define the filters
    stream.filter(
        tweet_fields=[
            "lang",
            "entities",
            "author_id",
            "created_at",
            "referenced_tweets",
        ]
    )