# Terraform Test

To fix:

Part 1
1. Fix all subnets (public and private), VPC CIDR must not be changes and submask used for subnets can be assumed to be correct.
2. Fix aws_nat_gateway resource and ensure it is fully working with the VPC.
3. Create Resources in order to run in 3 availability zones in Ireland region 

Part 2
Uncomment resources in ec2.tf
1. Create private instance in private subnet
2. Create bastion host to ssh into private instance
3. Ensure that you can ssh to public instance and from there jump onto private instance.
