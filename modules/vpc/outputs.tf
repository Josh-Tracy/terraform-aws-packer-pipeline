output "vpc_id" {
value = "${aws_vpc.vpc.id}"
}

output "subnet_a_id" {
value = "${aws_subnet.subnet_a.id}"
}

output "subnet_a_arn" {
value = "${aws_subnet.subnet_a.arn}"
}

output "subnet_b_id" {
value = "${aws_subnet.subnet_b.id}"
}

output "subnet_b_arn" {
value = "${aws_subnet.subnet_b.arn}"
}

output "subnet_c_id" {
value = "${aws_subnet.subnet_c.id}"
}

output "public_subnets"{
value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

output "private_subnets"{
value = [aws_subnet.subnet_c.id]
}