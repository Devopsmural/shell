# Specify the AWS details 
#- Connect to AWS using the given credentials & set the default region as as-south-1 (Mumbai)
provider "aws" {
  region = "ap-south-1"
}

# Specify the EC2 details
#- Create EC2 server using Ubuntu 18.0 AMI, then once the server is created install python on it
resource "aws_instance" "example" {
  ami           = "ami-0620d12a9cf777c87"
  instance_type = "t2.micro"
  key_name      = "wezva"

  # Install python on the new server created
  provisioner "remote-exec" {
    inline = [
     "sudo apt -y update",
     "sudo apt install -y python",
    ]
  }

  # Use the following ssh details to connect to the new server created
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("wezva.pem")
    host     = self.public_ip
  }

  # local-exec provisioner to call Ansible, which will install docker on the new server
  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i ${aws_instance.example.private_ip}, --private-key wezva.pem dockersetup.yml"
  }

}