resource "aws_msk_cluster" "my_msk_cluster" {
  cluster_name            = "my_msk_cluster"
  kafka_version           = "2.7.0"
  number_of_broker_nodes  = 2
  broker_node_group_type  = "DEFAULT"
  enhanced_monitoring     = "PER_BROKER"
  encryption_in_transit   = {
    client_broker = "TLS"
    in_cluster    = "TLS"
  }
  logging_info            = {
    broker_logs = {
      cloudwatch_logs = {
        enabled             = true
        log_group_name      = "msk_broker_logs"
        retention_in_days   = 30
        firehose_delivery_stream = null
      }
    }
  }
}

resource "aws_msk_topic" "my_topic" {
  name       = "my_topic"
  cluster_arn = aws_msk_cluster.my_msk_cluster.arn
  replication_factor = 2
  partitions = 1
}

resource "aws_msk_connector" "my_connector" {
  name                = "my_connector"
  service_name        = "my_service"
  kafka_cluster_arn   = aws_msk_cluster.my_msk_cluster.arn
  kafka_topic         = aws_msk_topic.my_topic.name
  kafka_bootstrap_servers = aws_msk_cluster.my_msk_cluster.bootstrap_brokers
  config {
    connector.class = "io.debezium.connector.postgresql.PostgresConnector"
    database.hostname = module.postgresql.address
    database.port     = module.postgresql.port
    database.user     = module.postgresql.username
    database.password = module.postgresql.password
    database.dbname   = module.postgresql.db_name
    database.server.name = "my_db_server_name"
    schema.whitelist  = "public"
    table.whitelist   = "public.*"
    plugin.name       = "pgoutput"
  }
}