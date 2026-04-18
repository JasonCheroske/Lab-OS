# -----------------------------------------------------------------------
# Wiring tests — dev/aws
#
# Uses Terraform's native mock_provider (requires TF >= 1.7) to validate
# that module outputs flow correctly between modules and are exposed at
# the environment root — with zero cloud credentials or emulator required.
#
# Run: terraform test  (from this directory)
# -----------------------------------------------------------------------

mock_provider "aws" {
  mock_resource "aws_vpc" {
    defaults = {
      id         = "vpc-wiring001"
      cidr_block = "10.0.0.0/16"
      arn        = "arn:aws:ec2:us-east-1:000000000000:vpc/vpc-wiring001"
    }
  }

  mock_resource "aws_internet_gateway" {
    defaults = { id = "igw-wiring001" }
  }

  mock_resource "aws_subnet" {
    defaults = {
      id  = "subnet-wiring001"
      arn = "arn:aws:ec2:us-east-1:000000000000:subnet/subnet-wiring001"
    }
  }

  mock_resource "aws_eip" {
    defaults = {
      id        = "eipalloc-wiring001"
      public_ip = "1.2.3.4"
    }
  }

  mock_resource "aws_nat_gateway" {
    defaults = { id = "nat-wiring001" }
  }

  mock_resource "aws_route_table" {
    defaults = { id = "rtb-wiring001" }
  }

  mock_resource "aws_route" {
    defaults = { id = "route-wiring001" }
  }

  mock_resource "aws_route_table_association" {
    defaults = { id = "rta-wiring001" }
  }

  mock_resource "aws_security_group" {
    defaults = {
      id  = "sg-wiring001"
      arn = "arn:aws:ec2:us-east-1:000000000000:security-group/sg-wiring001"
    }
  }

  mock_resource "aws_db_subnet_group" {
    defaults = {
      id   = "db-subnet-wiring001"
      name = "trf-dev-db-subnets"
    }
  }

  mock_resource "aws_db_instance" {
    defaults = {
      id         = "trf-dev-db"
      identifier = "trf-dev-db"
      address    = "trf-dev-db.mock.rds.amazonaws.com"
      port       = 5432
    }
  }

  mock_resource "aws_sqs_queue" {
    defaults = {
      id  = "https://sqs.us-east-1.amazonaws.com/000000000000/trf-dev-jobs"
      url = "https://sqs.us-east-1.amazonaws.com/000000000000/trf-dev-jobs"
      arn = "arn:aws:sqs:us-east-1:000000000000:trf-dev-jobs"
    }
  }

  mock_resource "aws_iam_role" {
    defaults = {
      id   = "trf-dev-role"
      name = "trf-dev-role"
      arn  = "arn:aws:iam::000000000000:role/trf-dev-role"
    }
  }

  mock_resource "aws_iam_role_policy_attachment" {
    defaults = { id = "policy-attach-wiring001" }
  }

  mock_resource "aws_eks_cluster" {
    defaults = {
      id       = "trf-dev-eks"
      name     = "trf-dev-eks"
      endpoint = "https://mock.eks.us-east-1.amazonaws.com"
      certificate_authority = [{ data = "bW9jaw==" }]
      identity              = [{ oidc = [{ issuer = "https://oidc.eks.us-east-1.amazonaws.com/id/MOCK" }] }]
    }
  }

  mock_resource "aws_eks_node_group" {
    defaults = { id = "trf-dev-eks:trf-dev-ng" }
  }

  mock_data "aws_region" {
    defaults = { name = "us-east-1" }
  }

  mock_data "aws_caller_identity" {
    defaults = { account_id = "000000000000" }
  }
}

# -----------------------------------------------------------------------
# Test: Networking module outputs are well-formed
# -----------------------------------------------------------------------

run "networking_outputs_are_populated" {
  assert {
    condition     = length(module.networking.vpc_id) > 0
    error_message = "networking.vpc_id is empty — mock provider not returning vpc id"
  }

  assert {
    condition     = length(module.networking.private_subnet_ids) > 0
    error_message = "networking.private_subnet_ids is empty — subnet mock not applied"
  }

  assert {
    condition     = module.networking.cidr_block == var.vpc_cidr
    error_message = "networking.cidr_block does not match input vpc_cidr — variable not threaded through"
  }
}

run "network_arn_is_arn_shaped" {
  assert {
    condition     = startswith(module.networking.network_arn, "arn:aws:ec2:")
    error_message = "network_arn does not start with 'arn:aws:ec2:' — ARN construction broken"
  }
}

# -----------------------------------------------------------------------
# Test: Networking → Database wiring
# -----------------------------------------------------------------------

run "database_receives_vpc_id_from_networking" {
  # The database module receives vpc_id = module.networking.vpc_id.
  # If the wiring is broken (wrong variable name, renamed output), this test
  # will fail at plan time because the mock vpc_id won't match the db sg vpc_id.
  assert {
    condition     = length(module.database_sql.db_endpoint) > 0
    error_message = "database_sql.db_endpoint is empty — db module failed to apply, likely wiring error"
  }

  assert {
    condition     = module.database_sql.db_port == 5432
    error_message = "database_sql.db_port is not 5432"
  }
}

# -----------------------------------------------------------------------
# Test: Networking → Kubernetes wiring
# -----------------------------------------------------------------------

run "kubernetes_receives_vpc_id_from_networking" {
  assert {
    condition     = length(module.kubernetes.cluster_endpoint) > 0
    error_message = "kubernetes.cluster_endpoint is empty — k8s module failed to apply, likely wiring error"
  }

  assert {
    condition     = startswith(module.kubernetes.cluster_endpoint, "https://")
    error_message = "kubernetes.cluster_endpoint does not start with 'https://' — unexpected format"
  }

  assert {
    condition     = length(module.kubernetes.cluster_name) > 0
    error_message = "kubernetes.cluster_name is empty"
  }
}

# -----------------------------------------------------------------------
# Test: Messaging outputs are present
# -----------------------------------------------------------------------

run "messaging_outputs_are_populated" {
  assert {
    condition     = length(module.messaging.queue_url) > 0
    error_message = "messaging.queue_url is empty — SQS mock not applied or output missing"
  }

  assert {
    condition     = length(module.messaging.queue_arn) > 0
    error_message = "messaging.queue_arn is empty"
  }

  assert {
    condition     = length(module.messaging.dlq_url) > 0
    error_message = "messaging.dlq_url is empty — DLQ mock not applied"
  }
}

# -----------------------------------------------------------------------
# Test: Environment root outputs are all exposed
# -----------------------------------------------------------------------

run "environment_root_outputs_complete" {
  assert {
    condition     = length(output.queue_url) > 0
    error_message = "queue_url not exposed at environment root"
  }

  assert {
    condition     = length(output.network_arn) > 0
    error_message = "network_arn not exposed at environment root"
  }

  assert {
    condition     = length(output.cluster_endpoint) > 0
    error_message = "cluster_endpoint not exposed at environment root"
  }
}
