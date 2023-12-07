# Real-Time E-Commerce Analytics Pipeline

## Introduction

In our rapidly evolving digital age, data engineering has become the backbone of the modern data-driven world. With the ever-increasing volume of data, the ability to process and analyze this data in real time is becoming a necessity rather than a luxury. This project presents a robust real-time e-commerce analytics pipeline using Kafka for data streaming, Spark for processing, and Docker for containerization, complemented by Elasticsearch for data storage and Kibana for visualization. Python serves as our primary scripting language to orchestrate this real-time e-commerce analytics adventure.

## Features

- **Data Generation**: Simulates real-time e-commerce data using the Faker library.
- **Kafka Integration**: Streams generated data into a Kafka cluster efficiently.
- **Spark Processing**: Applies real-time processing and analytics with Apache Spark.
- **Elasticsearch Storage**: Indexes and stores processed data for efficient retrieval.
- **Kibana Visualization**: Provides insightful visualizations of e-commerce metrics.

## Getting Started

### Prerequisites

- Docker and Docker Compose installed.
- Python 3.x.
- Access to an Elasticsearch instance.

### Installation and Setup

1. **Clone the Repository**

   ```sh
   git clone https://github.com/simardeep1792/Real-Time-E-Commerce-Analytics-Pipeline
   cd Real-Time-E-Commerce-Analytics-Pipeline

2. **Docker Setup**
   ```sh
   docker --version

4. **Starting the Services**
   ```sh
   chmod +x setup_cluster.sh
    ./setup_cluster.sh

This script initializes services like Kafka, Spark, Elasticsearch, and others in Docker containers.

### Usage
Data Generation: Run data_generation.py to start generating and streaming data.
Kibana for Visualization: Access Kibana at http://localhost:[Kibana-port] to visualize the data.

### Contributing
Contributions to this project are welcome. Please fork the repository and submit a pull request with your changes.
