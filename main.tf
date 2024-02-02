terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "name" {
  description = "Cluster/Application name"
  type = string
}

variable "cluster_tags" {
  description = "tags to add to the cluster"
  type = map(string)
}

variable "aws_region" {
  description = "AWS Region to operate in"
  type = string
  default = "us-east-2"
}

variable "cidr_block" {
  description = "A /16 CIDR range definition, such as 10.1.0.0/16, that the VPC will use"
  default = "10.1.0.0/16"
}

provider "aws" {
  region = var.aws_region
}

module "autoscaling_group_on_demand" {
  source = "./modules/autoscaling"
  name = "${var.name}-asg-on-demand"
}

module "autoscaling_group_spot" {
  source = "./modules/autoscaling"
  name = "${var.name}-asg-spot"
}

module "cluster" {
  source = "./modules/ecs/modules/cluster"
  cluster_name = var.name
  default_capacity_provider_use_fargate = false
  autoscaling_capacity_providers = {}
}