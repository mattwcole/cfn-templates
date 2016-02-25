#!/bin/sh

apt-get update
apt-get -y install python-setuptools
easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
