# Getting started with Kafka 
Apache Kafka is an open-source distributed event streaming platform designed for high-throughput, fault-tolerant, and scalable data streaming.
Kafka is built around publish-subscribe model, allowing producers to send messages to topics, and consumers to subscribe to topics to receive those messages. 
### Topic
Topics are logical channels in which messages are sent by producers, and from which messages are consumed by the consumers. Topics can receive messages of any format without any constraint, however, you cannot query from a topic directly, instead, we need to use consumers to read from any topic channel. Kafka topics are **immutable**, which means we cannot detele nor update 
### Partition 
Kafka topics can be split into partitions, which are the basic unit of parallelism and distribution. Partitions allow Kafka to scale and distribute data across multiple brokers.
### Broker
A Kafka broker is a server that stores and manages the messages published to Kafka topics. Brokers collectively form a Kafka cluster. Producers publish messages to brokers, which then store those messages on disk. Consumers read messages from brokers. As mentioned above, each topic can be made up of multiple partitions, and each partition can be hosted within a broker, in which the messages are stored. 
### Offset 
Offset is a unique identifier within a message in a topic. Consummers keep track of their progress by storing the offset of the last message sent. Offsets have meanings only within a specific partition, meaning that offset 3 in partition 1, does not correspond to offset 3 in partition 2. So, the order of messages are reserved within a partition, but not across partitions. 
### Producers
Producers write data to partitions within a topic. This means that the client application (producer) knows in advance on which partition it's sending the data to, and which message broker is accommodating that partition. Producers can choose to send messages along with a message key. If they provide this optional parameter, messages with similar keys will end up in the same partition, thanks to a hashing strategy. 
### Consumers 
Consumers make requests to the topic brokers, the servers, and get a response back. This is called the pull model. A consumer can choose which partition to read the data from. In case there's a server failure on that partition, consumers know how to recover from it. Within each partitions, the offsets will be read in order. The data is read is bytes format, and the key-values will be deserialized by the consumer into their native format (int, string, etc.). The consumers know the expected format of the key values and choose the right serializer accordingly; this mean that the moment the topic is created, we must not change the data type in order to not break the consumer. So, in case you'd like to change the data type, we must create a new topic with the desired data type.
**NOTE -** Each consumer will only read from the last commited offset; so, for a consumer that has already consumed all the messages, the --from-beginning argument will not be taken into account.
### Key & value
In Kafka, each message consists of a key and a value. Both the key and value can be serialized separately. The key is typically used for partitioning messages, while the value carries the actual data.
### Kafka Message serielization and deserielization
Serialization is a crucial aspect of Kafka's design because it ensures that messages can be efficiently transmitted and processed by Kafka brokers, producers, and consumers while maintaining compatibility and efficiency. When a producer sends a message to a Kafka topic, it serializes the key and value from their native format into a binary format. Conversely, when a consumer receives a message, it deserializes the binary key and value back into their native format for processing. Kafka provides pluggable serializers and deserializers for various data formats. Common serialization formats include Avro, JSON, and Protobuf. You can also implement custom serializers to handle specific data formats. Proper message serialization can have a significant impact on Kafka's efficiency and performance. Choosing the right serialization format for your use case and ensuring proper serialization and deserialization practices are essential for a smooth Kafka deployment. Efficient serialization reduces the size of messages, leading to lower storage and network transfer costs and faster message processing.
### How clients connect to a Kafka cluster
Each Kafka broker in your cluster is called a bootstrap server. In this cluster of brokers, we only need to connect to this one broker and then the clients will know how to be connected to the entire cluster. So, the Kafka client is going to initiate a connection into this broker, as well as a metadata request; once successful, the bootstrap server is going to return the list of all the brokers in the cluster. When the client has access to that metadate, it will know to which broker it'll need to connect, and which partitions are hosted into which broker. This metadate is available to each broker within the cluster, meaning that the brokers are fully aware of one another within the cluster. 
### Topic Replication Factor
Topics need to have a replication factor greater than one, usually between two and three and most commonly at three. So that way, if a broker is down, that means a Kafka server is stopped for maintenance or for a technical issue. Then another Kafka broker still has a copy of the data to serve and receive. So, it's possible for brokers to replicate data from other brokers. **As a general rule, for a replication factor of N, we can permanently lose up to N-1 brokers and still recover your data.**
### acknowledgments 
Here's what acks can be set to, along with their meanings:

- acks=0: The producer does not wait for any acknowledgment from the broker. It sends the message and does not care about whether it's received or not. This setting provides the lowest latency but offers no durability guarantees.

- acks=1: The producer waits for an acknowledgment from the leader broker. This means that the message is considered sent once it reaches the leader. It provides a balance between low latency and some level of durability.

- acks=all (or acks=-1): The producer waits for acknowledgment from all in-sync replicas (ISR) of the partition. This setting ensures the highest level of durability because the message is only considered sent when it's received and acknowledged by all replicas in the ISR. It offers the strongest durability guarantees but can introduce higher latency compared to the other settings.

Setting acks=all is a good choice when data integrity and durability are critical, and you can tolerate the additional latency introduced by waiting for acknowledgments from all replicas. However, keep in mind that it may have an impact on the overall throughput and latency of your Kafka producer, so you should consider your use case and requirements when selecting the appropriate acks setting.

An important thing to note is that at any given time, only 1 broker can be a leader of a partition (the main server that hosts that partition); and the producers can only send data to the leader of a partition. Similarly, consumers will only read data from the leader of a partition by default.
Since Kafka 2.4, however, it is possible to configure consumers to read from the closest broker, potentially a replica, to improve latency and improve network costs, especially in the cloud.

# Kafka CLI
Use the ```kafka-topics``` command to get a list of all possible kafka-topics possible command. In the following commands, we assume there's a Bootstrap server up & running called: ```kafka:9092```. 
- Get a list of all existing topics in your broker: 
```
kafka-topics --list  --bootstrap-server <server_name>
``` 
- We can create a topic using the below command:
```
kafka-topics --create --topic <topic_name> --partitions 1 --replication-factor 1 --if-not-exists --bootstrap-server <server_name>
```
Use the ```--partitions``` and ```--replication-factor``` arguments to choose the right number of partitions and replication factor for the topics.
- In order to create a producer and send messages to a topic, use the following command: 
```
kafka-console-producer --bootstrap-server <server_name> --topic <topic_name>
``` 
- In order to further consume from that topic, use the below command:
```
kafka-console-consumer --bootstrap-server <server_name> --topic <topic_name> --formatter kafka.tools.DefaultMessageFormatter --property print.key=true --property print.value=true --property print.partition=true --property print.timestamp=true --from-beginning
``` 
The ```--from-beginning``` argument will read all available messages in the topic. If you need to read from a specific partition, use the ```--partition <parttition_id>``` argument. We can also use the ```--property print.key=true``` argument to print the keys along with the values. Also, in order to create multiple consumers within a group to scale the read operations, we can use the ```--group <group_name>``` argument. In this way, each consumer will read from a separate partition scaling the Kafka application. 
- In order to produce messages with keys, use the below command: 
```
kafka-console-producer --bootstrap-server <server_name> --topic <topic_name> -property parse.key=true -property key.separator=:
```
We passed the ```-property parse.key=true``` argument to specify that the message is associated with a key, and the ```-property key.separator=:``` argument to specify that the key and the value are separated with a semi-column. 
**NOTE -** In order to producer the messages randomly to all partitions, use the ```--producer-property partitioner.class=org.apache.kafka.clients.proer.RoundRobinPartitioner``` argument. This will not be useful in production, but it allows you to observe how multiple consumers in a consumer group would read from all partitions.

- Consumer groups are an important concept in Kafka for scaling the read operations. Multiple consumers can be set up within a group to read from multiple partitions in a kafka topic. Use the below command to get a list of consumer groups:
```
kafka-consumer-groups --list --bootstrap-server <server_name>
```
- Use the below command to get more details on every consumer within that group. We can see details like what partition each consumer is reading from, what's the current offset within that partition, and the Lag associated to that consumer, meaning the number of messages that have been produced, but not yes consumed by that consumer. 
```
kafka-consumer-groups --group <group_name> --bootstrap-server <server_name> --describe
```
- Use the below command to reset the offsets of a consumer group to be able to ingest the messages from the beginning: 
```
kafka-consumer-groups --bootstrap-server <server_name> --group <group_name> --topic <topic_name> --reset-offsets --to-earliest --execute
```
# Kafka Docker Compose Quickstart
This guide will walk you through setting up a simple Kafka cluster using Docker Compose, creating a Kafka topic, producing a message, and consuming that message.
### Prerequisites
Before you begin, make sure you have the following installed on your system:
- Docker
- Docker Compose
### Understanding the docker-compose.yml File
We used Docker Compose to pull the Zookeeper and Kafka images and run them as Docker Containers. We've used [this](https://github.com/conduktor/kafka-stack-docker-compose/blob/master/full-stack.yml) configuration file; we'll go through the services specified in this file:
#### Zookeeper
ZooKeeper is a distributed coordination service required by Kafka for managing distributed brokers. It helps maintain metadata, leader election, and synchronization in a Kafka cluster. We used and pulled the ```confluentinc/cp-zookeeper:7.0.0``` image from Dockerhub. Read their [official page](https://hub.docker.com/_/zookeeper) on Dockerhub for more details. 
#### Kafka Service
Kafka is the core message broker responsible for managing topics, partitions, and message distribution within the Kafka cluster. It relies on ZooKeeper for coordination and management.
#### Advertised listeners
Once we have the cluster up & running, we would like to communicate to it through the local machine. We would like to programmatically send data to a topic using python. The Kafka cluster will be running inside the container, which is an isolated environement, and is not normally known to the host machine, however, by adding and external listerner and exposing its port, we'll be able to communicate with the broker through the host machine. In the configuration file we've added the following external listener and exposed its port: ```EXTERNAL://${DOCKER_HOST_IP:-127.0.0.1}:9092```. So, 127.0.0.1:9092 (127.0.0.1 is the default port in case DOCKER_HOST_IP has not been defined) will be used as a bootstrap server in our python code.
#### Starting up the clusters
In order to get the two services up & running, run the ```docker-compose up -d``` command. Once that's done, go inside the container by running ```docker exec -it <image_id> sh```. Once inside the container we're ready to run Kafka CLI commands.
## 