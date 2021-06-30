resource "aws_key_pair" "cic_keypair" {
  key_name   = var.application
  public_key = local.cic_ec2_data["public-key"]
}