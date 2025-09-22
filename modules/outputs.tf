output "main_vpc" {
    value = aws_vpc.main-vpc.id
}

output "public_cidr"{
    value = "10.0.1.0/24"
}

output "public_subnet_id"{
    value = aws_subnet.public.id
}

output "private_subnet_id"{
    value = aws_subnet.private.id
}

output "private2_subnet_id"{
    value = aws_subnet.private2.id
}