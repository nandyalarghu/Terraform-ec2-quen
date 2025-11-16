#!/bin/bash

# Script to initialize and plan Terraform for simple example
# Usage: ./scripts/init-plan-simple.sh

set -e

echo "Navigating to simple example directory..."
cd examples/simple

echo "Initializing Terraform..."
terraform init

echo "Running Terraform plan..."
terraform plan

echo "Plan completed successfully!"