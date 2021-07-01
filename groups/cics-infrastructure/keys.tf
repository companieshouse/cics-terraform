resource "aws_key_pair" "cics_keypair" {
  key_name   = var.application
  public_key = local.cics_ec2_data["public-key"]
}