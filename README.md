# Terraform Test

To fix:

Part 1
1. Fix subnet both public and private CIDR ranges (mask in this case is correct)
2. Fix aws_nat_gateway resource
3. Create Resources in order to run in 3 availability zones in Ireland region

Part 2
Uncomment resources in ec2.tf
1. Create private instance in private subnet
2. Create bastion host to ssh into private instance
