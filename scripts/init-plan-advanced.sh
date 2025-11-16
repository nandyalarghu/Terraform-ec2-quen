#!/bin/bash

# Script to initialize and plan Terraform for advanced example
# Usage: ./scripts/init-plan-advanced.sh

set -e

echo "Navigating to advanced example directory..."
cd examples/advanced

echo "Initializing Terraform..."
terraform init

echo "Running Terraform plan..."
terraform plan

echo "Plan completed successfully!"