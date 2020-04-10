# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
    required_version = ">= 0.12"
    experiments = [variable_validation]
}

# ----------------------------------------------------------------------------------------------------------------------
/* VPC --> Internet Gateway {
    Subnet 1 (Public) --> Route Table (we need to associate it to each subnet) 
        --> Route (destination (CIDR inbound) --> target (Internet Gateway)) {
            EC2-1,
            EC2-2,
            LoadBalance,
            NAT Gateway (it must be associate with a public subnet), which gives access to the internet from 
            private subnet. NAT Gateway will make a bridge between the private EC2 to the NAT Gateway
    }

    Subnet 2 (Private) --> Route Table (we need to associate it to each subnet)
        --> Route (destination (CIDR inbound) --> target (local)) {
            EC2-1,
            EC2-2,
            EC2-3,
    }
}

We first create the VPC, then we need to create/associate a Internet Gateway (IGW) to the VPC. 
Observe we can only have one IGW per VPC. The creation of the IGW doesn't guarantee you can access the EC2 inside 
your VPC/Subnet. We need to create a Route Table and a Route. The Route contains the CIDR (Inbound) and the Target */
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# This tag must exist on subnet resource in order to create the Node Group
# ----------------------------------------------------------------------------------------------------------------------

locals {
    subnet_common_tags = {
        "kubernetes.io/cluster/mainCluster" = "shared"
        # anyOtherKey = anyOtherValue
    }
}

# ----------------------------------------------------------------------------------------------------------------------
# 
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "eksVpc" {
    count = var.should_be_created ? 1 : 0

    cidr_block = var.vpc_block
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "eksVpc"
        Environment = "development"
    }
}

# -------------- Internet Gateway --------------
# Observe that there's no AWS VPCGatewayAttachment in Terraform. 
# The aws_internet_gateway resource will create the Internet Gateway and attach it to the specified VPC.
# That's make sense because there is only one internet gateway per VPC
resource "aws_internet_gateway" "eksVpcInternetGateway" {
    count = var.should_be_created ? 1 : 0
    vpc_id = aws_vpc.eksVpc.id

    tags = {
        Name = "eksVpcInternetGateway"
    }
}

# -------------- Route Tables --------------
resource "aws_route_table" "publicRouteTable" {
    vpc_id = aws_vpc.eksVpc.id

    # route {
    #     cidr_block = var.publicBlock
    #     gateway_id = aws_internet_gateway.eksVpcInternetGateway.id
    # }

    # tags = {
    #     Name = "Public Subnets"
    #     Network = "Public"
    # }
}

resource "aws_route_table" "privateRouteTable01" {
    vpc_id = aws_vpc.eksVpc.id

    tags = {
        Name = "Private Subnet AZ1"
        Network = "Private 01"
    }
}

resource "aws_route_table" "privateRouteTable02" {
    vpc_id = aws_vpc.eksVpc.id

    tags = {
        Name = "Private Subnet AZ2"
        Network = "Private 02"
    }
}

# -------------- Routes --------------
resource "aws_route" "publicRoute" {
    route_table_id = aws_route_table.publicRouteTable.id
    destination_cidr_block  = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eksVpcInternetGateway.id
}

resource "aws_route" "privateRoute01" {
    route_table_id = aws_route_table.privateRouteTable01.id
    destination_cidr_block  = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natGateway01.id
}

resource "aws_route" "privateRoute02" {
    route_table_id = aws_route_table.privateRouteTable02.id
    destination_cidr_block  = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natGateway02.id
}

# -------------- Nat Gateways --------------
resource "aws_nat_gateway" "natGateway01" {
    allocation_id = aws_eip.natGatewayEIP1.id
    subnet_id = aws_subnet.publicSubnet01.id
}

resource "aws_nat_gateway" "natGateway02" {
    allocation_id = aws_eip.natGatewayEIP2.id
    subnet_id = aws_subnet.publicSubnet02.id
}

# -------------- EIP --------------
resource "aws_eip" "natGatewayEIP1" {
    vpc = true
}

resource "aws_eip" "natGatewayEIP2" {
    vpc = true
}

# -------------- Subnets --------------
resource "aws_subnet" "publicSubnet01" {
    vpc_id = aws_vpc.eksVpc.id
    cidr_block = var.publicSubnet01Block
    map_public_ip_on_launch = true
    # availability_zone = 

    # tags = {
    #     Name = "publicSubnet01"
    #     "kubernetes.io/cluster/mainCluster" = "shared" # This tag must exist in order to create the Node Group
    # }

    tags = local.subnet_common_tags
}

resource "aws_subnet" "publicSubnet02" {
    vpc_id = aws_vpc.eksVpc.id
    cidr_block = var.publicSubnet02Block
    map_public_ip_on_launch = true
    # availability_zone = 

    # tags = {
    #     Name = "publicSubnet02",
    #     "kubernetes.io/cluster/mainCluster" = "shared" # This tag must exist in order to create the Node Group
    # }

    tags = local.subnet_common_tags
}

resource "aws_subnet" "privateSubnet01" {
    vpc_id = aws_vpc.eksVpc.id
    cidr_block = var.privateSubnet01Block
    # availability_zone = 

    # tags = {
    #     Name = "privateSubnet01",
    #     "kubernetes.io/cluster/mainCluster" = "shared" # This tag must exist in order to create the Node Group
    # }

    tags = local.subnet_common_tags
}

resource "aws_subnet" "privateSubnet02" {
    vpc_id = aws_vpc.eksVpc.id
    cidr_block = var.privateSubnet02Block
    # availability_zone = 

    # tags = {
    #     Name = "privateSubnet02",
    #     "kubernetes.io/cluster/mainCluster" = "shared" # This tag must exist in order to create the Node Group
    # }

    tags = local.subnet_common_tags
}

# -------------- Subnet/Route Table Association --------------
resource "aws_route_table_association" "publicSubnet01RouteTableAssociation" {
    subnet_id      = aws_subnet.publicSubnet01.id
    route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_route_table_association" "publicSubnet02RouteTableAssociation" {
    subnet_id      = aws_subnet.publicSubnet02.id
    route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_route_table_association" "privateSubnet01RouteTableAssociation" {
    subnet_id      = aws_subnet.privateSubnet01.id
    route_table_id = aws_route_table.privateRouteTable01.id
}

resource "aws_route_table_association" "privateSubnet02RouteTableAssociation" {
    subnet_id      = aws_subnet.privateSubnet02.id
    route_table_id = aws_route_table.privateRouteTable02.id
}

# -------------- Security Group --------------
resource "aws_security_group" "allow_tls" {
    name = "vpcSecurityGroup"
    description = "Cluster communication with worker nodes"
    vpc_id = aws_vpc.eksVpc.id
}