resource "null_resource" "ansible" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = "./ansible"
    command = <<EOT
      sleep 120 #time to allow VMs to come online and stabilize
      mkdir -p ./logs
      
      # Private key
      sed -i "s/private_key/${var.key-pair}/g" template/ssh_config

      # NLB DNS Name
      sed -i "s/nlb_url/${module.load-balancer.nlb-dns-name}/g" roles/frontend/files/default

      # Frontend IPs
      sed -i '/frontend_ip/r frontend_ips.tmp' template/inventory && sed -i '/frontend_ip/d' template/inventory
      rm -r frontend_ips.tmp

      # Backend IPs
      sed -i '/backend_ip/r backend_ips.tmp' template/inventory && sed -i '/backend_ip/d' template/inventory
      rm -r backend_ips.tmp

      # Ansible
      ansible-playbook site.yml
    EOT
  }

  depends_on = [
    aws_instance.backend-servers,
    aws_instance.frontend-servers,
    aws_instance.bastion-server,
    module.load-balancer
  ]
}