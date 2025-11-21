resource "local_file" "ansible_inventory" {
  filename = "./inventory.ini"

  content = <<EOF
[all]
${aws_instance.frontend.public_ip}
${aws_instance.backend.public_ip}

[frontend]
${aws_instance.frontend.public_ip}

[backend]
${aws_instance.backend.public_ip}
EOF
}