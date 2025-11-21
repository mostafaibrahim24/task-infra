[all]
${backend_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./appinstances-kp.pem
${frontend_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./appinstances-kp.pem

[backend]
${backend_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./appinstances-kp.pem

[frontend]
${frontend_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./appinstances-kp.pem
