#!/bin/bash
sudo -i
cd /root/
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc openssl-devel zlib-devel pcre-devel
wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.2-1.el8.ngx.src.rpm
rpm -i nginx*
wget https://github.com/openssl/openssl/archive/refs/heads/OpenSSL_1_1_1-stable.zip
unzip OpenSSL_1_1_1-stable.zip
sed -i '114i\    --with-openssl=/root/openssl-OpenSSL_1_1_1-stable \\' /root/rpmbuild/SPECS/nginx.spec
yum-builddep rpmbuild/SPECS/nginx.spec
rpmbuild -bb ~/rpmbuild/SPECS/nginx.spec
ls -l ~/rpmbuild/RPMS/x86_64/
yum localinstall -y ~/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm
systemctl start nginx
curl -I -s localhost:80 | head -n 1 | awk '{print $2}'
mkdir /usr/share/nginx/html/repo
cp ~/rpmbuild/RPMS/x86_64/nginx-1* /usr/share/nginx/html/repo/
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm
createrepo /usr/share/nginx/html/repo/
sed -i '10i\        autoindex on;' /etc/nginx/conf.d/default.conf
nginx -t
nginx -s reload
curl -a http://localhost/repo
echo -e "[otus]\nname=otus-linux\nbaseurl=http://localhost/repo\ngpgcheck=0\nenabled=1" >> /etc/yum.repos.d/otus.repo
yum install percona-orchestrator.x86_64 -y

