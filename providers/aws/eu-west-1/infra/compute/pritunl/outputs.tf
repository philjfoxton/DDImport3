output "vpn_ip" {
  value = aws_eip.pritunl.public_ip
}

output "vpn_sg" {
  value = module.pritunl_sg.this_security_group_id
}
