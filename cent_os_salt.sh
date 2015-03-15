#!/bin/sh

#############################################################################
#
# Provision a CentOS server with dev-python & salt
#  ./script minion master   <== installs both minion & master software
#  Mispell minion or master to let it move forward without installing
#
#############################################################################

ISMINION="$1"
ISMASTER="$2"

yum -y update

yum groupinstall -y development

yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel

wget http://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz

yum install xz-libs

xz -d Python-2.7.9.tar.xz

tar -xvf Python-2.7.9.tar

cd Python-2.7.9

./configure

make && make altinstall

cd ..

wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz

tar -xvf setuptools-1.4.2.tar.gz

cd setuptools-1.4.2

python setup.py install

curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python -

pip install virtualenv

cd ..

rpm -Uvh epel-release-X-Y.rpm

wget http://mirror.pnl.gov/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

rpm -Uvh epel-release-7-5.noarch.rpm

if ["$ISMASTER" == "master"]; then
	echo "MASTER IS STARTING..."
	yes | yum install -y salt-master

	chkconfig salt-master on

	service salt-master start
fi

if ["$ISMINION" == "minion"]; then
	echo "MINION IS STARTING..."
	yes | yum install -y salt-minion

	chkconfig salt-minion on

	service salt-minion start 
fi

 
