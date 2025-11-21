[all]
${backend_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./appinstances-kp.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'
${frontend_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./appinstances-kp.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[backend]
${backend_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./appinstances-kp.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[frontend]
${frontend_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./appinstances-kp.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'
