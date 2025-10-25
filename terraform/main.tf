# Terraform Infrastructure as Code
terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS EKS Cluster
resource "aws_eks_cluster" "cybersecurity_capstone" {
  name     = "cybersecurity-capstone-cluster"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.28"

  vpc_config {
    subnet_ids              = aws_subnet.private[*].id
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_cloudwatch_log_group.eks_cluster,
  ]

  tags = {
    Name        = "cybersecurity-capstone-cluster"
    Environment = "production"
    Project     = "cybersecurity-capstone"
  }
}

# EKS Node Group
resource "aws_eks_node_group" "cybersecurity_capstone" {
  cluster_name    = aws_eks_cluster.cybersecurity_capstone.name
  node_group_name = "cybersecurity-capstone-nodes"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = aws_subnet.private[*].id

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium", "t3.large"]

  scaling_config {
    desired_size = 3
    max_size     = 10
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry_policy,
  ]

  tags = {
    Name        = "cybersecurity-capstone-nodes"
    Environment = "production"
    Project     = "cybersecurity-capstone"
  }
}

# RDS PostgreSQL Database
resource "aws_db_instance" "cybersecurity_capstone" {
  identifier = "cybersecurity-capstone-db"

  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true

  db_name  = "pentest_results"
  username = "pentest_user"
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.cybersecurity_capstone.name

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  skip_final_snapshot = false
  final_snapshot_identifier = "cybersecurity-capstone-final-snapshot"

  tags = {
    Name        = "cybersecurity-capstone-db"
    Environment = "production"
    Project     = "cybersecurity-capstone"
  }
}

# ElastiCache Redis
resource "aws_elasticache_replication_group" "cybersecurity_capstone" {
  replication_group_id       = "cybersecurity-capstone-redis"
  description                = "Redis cluster for cybersecurity capstone"

  node_type            = "cache.t3.micro"
  port                 = 6379
  parameter_group_name = "default.redis7"

  num_cache_clusters = 2

  subnet_group_name  = aws_elasticache_subnet_group.cybersecurity_capstone.name
  security_group_ids = [aws_security_group.redis.id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  tags = {
    Name        = "cybersecurity-capstone-redis"
    Environment = "production"
    Project     = "cybersecurity-capstone"
  }
}

# Application Load Balancer
resource "aws_lb" "cybersecurity_capstone" {
  name               = "cybersecurity-capstone-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Name        = "cybersecurity-capstone-alb"
    Environment = "production"
    Project     = "cybersecurity-capstone"
  }
}

# Variables
variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

# Outputs
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.cybersecurity_capstone.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = aws_eks_cluster.cybersecurity_capstone.vpc_config[0].cluster_security_group_id
}

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.cybersecurity_capstone.dns_name
}
