output "vpc_id" {
value =  aws_vpc.main.id
}


output "public_subnet1_id" { 
 value = aws_subnet.public[0].id

}

output "public_subnet2_id" { 
 value = aws_subnet.public[1].id

}

output "public_subnet3_id" { 
 value = aws_subnet.public[2].id

}

output "private_subnet1_id" { 
 value = aws_subnet.private[0].id

}

output "private_subnet2_id" { 
 value = aws_subnet.private[1].id

}

output "private_subnet3_id" { 
 value = aws_subnet.private[2].id

}

