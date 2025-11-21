# Generate a local Ansible inventory file dynamically
resource "local_file" "ansible_inventory" {
  filename = "./inventory.ini"

  content = templatefile("${path.module}/inventory.tpl", {
    backend_ip  = aws_instance.backend.public_ip
    frontend_ip = aws_instance.frontend.public_ip
  })
}