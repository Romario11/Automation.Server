#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo aws s3 cp s3://my-special-bucket-rs/ /usr/share/nginx/html --recursive