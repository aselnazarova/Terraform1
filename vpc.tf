resource "aws_vpc" "asel_vpc" {
    
  cidr_block       = "10.2.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "asel_main_vpc"
    Department = "Production"
    Created_by = "Asel"
  }

}