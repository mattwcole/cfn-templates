#!/bin/sh

apt-get update
apt-get -y install python3-pip
pip3 install pystache==0.5.4  # https://www.reddit.com/r/aws/comments/rcpeft/awscfnbootstrap_pip_install_broken_by_new/
pip3 install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-py3-2.0-6.tar.gz
