#!/bin/bash


# Check if the cluster is already set up
sudo rm -r esdata1
sudo rm -r kafka-ce 
sudo rm -r spark-processing
sudo rm -r spark-checkpoint


# Function to create volumes for various services
create_volumes() {
    service=$1
    shift

    echo "Creating volumes for ${service} ..."
    for item in "$@"
    do
        echo "$item"
        mkdir -p "$item"
        sudo chown -R "$(id -u)" "$item"
        sudo chgrp -R "$(id -g)" "$item"
        sudo chmod -R u+rwX,g+rX,o+wrx "$item"
        echo "$item volume is created."
    done
    echo "Volumes for ${service} created ✅"
    echo 
}

# Load environment variables from .env file
source .env

# # Create volumes for different services
create_volumes zookeeper kafka-ce/zk/data kafka-ce/zk/txn-logs
create_volumes brokers kafka-ce/broker/data kafka-ce/broker2/data kafka-ce/broker3/data kafka-ce/broker4/data
create_volumes schema-registry kafka-ce/schema-registry/data
create_volumes connect kafka-ce/connect/data kafka-ce/connect/plugins
create_volumes ksqldb-cli kafka-ce/ksqldb-cli/scripts
create_volumes filepulse kafka-ce/connect/data/filepulse/xml
create_volumes elasticsearch esdata1
create_volumes spark_master spark-processing
create_volumes spark_master spark-checkpoint

cp spark-processing.py spark-processing 
export PWD=$(pwd)

# Start all services using Docker Compose
echo "Starting all services ..."
docker compose -f docker-compose.yaml up -d

# Set timeout for readiness checks
timeout=600
echo ''

# Check readiness for Zookeeper
zookeeper="zookeeper:${ZOOKEEPER_CLIENT_PORT}"
echo "Wait for ${zookeeper} ..."
docker exec -it zookeeper cub zk-ready "$zookeeper" $timeout > /dev/null
echo "${zookeeper} is ready ✅"
echo ''

# Check readiness for Kafka brokers
for item in broker:${BROKER_INTERNAL_PORT} broker2:${BROKER2_INTERNAL_PORT}
do
    broker="$item"
    echo "Wait for ${broker} ..."
    docker exec -it zookeeper cub kafka-ready -b "$broker" 1 $timeout > /dev/null
    echo "${broker} is ready ✅"
    echo ''
done

# Check readiness for Schema Registry
schema_registry_host="schema-registry"
schema_registry_port="${SCHEMA_REGISTRY_PORT}"
echo "Wait for ${schema_registry_host}:${schema_registry_port} ..."
docker exec -it zookeeper cub sr-ready "$schema_registry_host" $schema_registry_port $timeout > /dev/null
echo "${schema_registry_host}:${schema_registry_port} is ready ✅"
echo ''

# Check readiness for Kafka Connect
# for item in connect connect2 connect3
for item in connect
do
    connect_host="$item"
    connect_port="${CONNECT_PORT}"
    echo "Wait for ${connect_host}:${connect_port} ..."
    docker exec -it zookeeper cub connect-ready "$connect_host" $connect_port $timeout > /dev/null
    echo "${connect_host}:${connect_port} is ready ✅"
    echo ''
done

echo "Kafka cluster is ready ✅"
