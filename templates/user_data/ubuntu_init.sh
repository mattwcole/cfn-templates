#!/bin/sh

apt-get update
apt-get -y install python3-pip
pip3 install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-py3-2.0-6.tar.gz
