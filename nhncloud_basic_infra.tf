# Provider 설정
provider "nhncloud" {
  access_key = "{secret}"
  secret_key = "{secret}"
}

# VPC 생성
resource "nhncloud_vpc" "example_vpc" {
  name      = "example-vpc"
  cidr_block = "10.120.x.x/16"
}

# Subnet 생성
resource "nhncloud_subnet" "example_subnet" {
  name                = "example-subnet"
  cidr_block          = "10.120.x.x/24"
  vpc_no              = nhncloud_vpc.example_vpc.id
  availability_zone_no = 1
}

# Internet Gateway 생성
resource "nhncloud_internet_gateway" "example_igw" {
  name = "example-igw"
  vpc_no = nhncloud_vpc.example_vpc.id
}

# 로드밸런서
resource "nhncloud_loadbalancer" "example_lb" {
  name             = "keepalive-lb"
  vpc_no           = nhncloud_vpc.example_vpc.id
  subnet_no_list   = [nhncloud_subnet.example_subnet.id]
  internet_gateway_no = nhncloud_internet_gateway.example_igw.id
  load_balancer_rule_list {
    protocol   = "TCP"
    load_balancer_port = 6443
    instance_port = 6443
  }
}

# 인스턴스 
resource "nhncloud_instance" "example_instance" {
  name         = "example-instance"
  image_no     = "CENTOS-7.8-64-LAMP-1.0.3"
  login_key_name = "example-key"
  instance_type_no = "STD-B-1"
  subnet_no    = nhncloud_subnet.example_subnet.id
  public_ip    = true
  security_group_no_list = ["sg-0123456789abcdefg"]
}
