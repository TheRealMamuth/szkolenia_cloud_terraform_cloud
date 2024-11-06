resource "digitalocean_project" "main" {
  name = "Szkolenia Cloud Example"
  description = "This is a project for the Szkolenia Cloud Example"
  purpose = "This project is for the Szkolenia Cloud Example"
  environment = "development"
  resources = [digitalocean_droplet.main.urn]
}

resource "digitalocean_vpc" "main" {
    name = "Szkolenia-Cloud-Example-VPC-NEW"
    region = "fra1"
    description = "This is a VPC for the Szkolenia Cloud Example"
    ip_range = "10.100.0.0/24"
}

resource "digitalocean_droplet" "main" {
    name = "Szkolenia-Cloud-Example-Droplet"
    image ="ubuntu-20-04-x64"
    region = "fra1"
    size = "s-1vcpu-1gb"
    vpc_uuid = digitalocean_vpc.main.id
}

resource "digitalocean_firewall" "main" {
    name = "Szkolenia-Cloud-Example-Firewall"
    droplet_ids = [ digitalocean_droplet.main.id]
    inbound_rule {
        protocol = "tcp"
        port_range = "22"
        source_addresses = ["0.0.0.0/0"]
    }
    outbound_rule {
        protocol = "icmp"
        destination_addresses = ["0.0.0.0/0"]
    }
    outbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        destination_addresses = ["0.0.0.0/0"]
    }
    outbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        destination_addresses = ["0.0.0.0/0"]
    }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.100.0.0/24"
    availability_zone = "eu-central-1a"
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
}

resource "aws_route_table_association" "main" {
    subnet_id = aws_subnet.main.id
    route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  name = "Szkolenia Cloud Example Security Group"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 1
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 1
        to_port = 65535
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "main" {
    ami = "ami-0faab6bdbac9486fb"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.main.id
    vpc_security_group_ids = [aws_security_group.main.id]
    associate_public_ip_address = true
}

