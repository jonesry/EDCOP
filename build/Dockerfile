FROM centos:7.4.1708

RUN yum -y --disablerepo=* --enablerepo=base --enablerepo=extras --enablerepo=updates install epel-release wget isomd5sum createrepo mkisofs yum-utils mtools dosfstools syslinux

RUN yum -y install http://repos.sealingtech.org/edcop/edcop-packages/edcop-repo-1-1.noarch.rpm 

COPY . /EDCOP

RUN cd /EDCOP/build && ./online-configure.sh && ./build-image.sh && rm -rf ~/build
