resource "aws_instance" "main" {
  ami           = "ami-xxxxxx"
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 25
    volume_type = "io2"

  }
  tags = {
    Name  = "main"
    owner = "Umid"
  }
}
