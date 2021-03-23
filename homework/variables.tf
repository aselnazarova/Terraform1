variable key_name {
    default = "tf_key"
    }

variable ssh_key_path {
    default = "~/.ssh/id_rsa.pub"
    }

variable region {
    default = "us-east-1"
    }

variable cidr_block_subnet1 {
    default = "10.0.1.0/24"
    }

variable cidr_block_subnet2 {
    default = "10.0.2.0/24"
    }

variable ami {
    default = "ami-0533f2ba8a1995cf9"    
}

variable instance_type {
  default = "t2.micro"
}

variable cidr_block_vpc {
  default = "10.0.0.0/16"
}

variable cidr_block_route {
  default = "0.0.0.0/0"
}