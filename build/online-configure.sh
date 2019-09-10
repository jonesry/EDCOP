#!/bin/bash
BUILDDIR=~/build
ISOLINUXDIR=$BUILDDIR/isolinux
BASEURL=http://mirror.umd.edu/centos/7/os/x86_64/

mkdir -p $ISOLINUXDIR
curl -s --list-only $BASEURL/repodata/ | sed -n 's/.*href="\([^"]*comps.xml\)[^.].*/\1/p' | xargs -I% curl  --create-dirs $BASEURL/repodata/% -o $BUILDDIR/comps.xml

mkdir -p $ISOLINUXDIR/{EXTRAS,images,isolinux,ks,LiveOS,Packages,repodata,EFI}

curl --create-dirs $BASEURL/LiveOS/squashfs.img -o $ISOLINUXDIR/LiveOS/squashfs.img
curl --create-dirs $BASEURL/isolinux/boot.msg -o $ISOLINUXDIR/isolinux/boot.msg
curl --create-dirs $BASEURL/isolinux/grub.conf -o $ISOLINUXDIR/isolinux/grub.conf
curl --create-dirs $BASEURL/isolinux/initrd.img -o $ISOLINUXDIR/isolinux/initrd.img
curl --create-dirs $BASEURL/isolinux/isolinux.bin -o $ISOLINUXDIR/isolinux/isolinux.bin
curl --create-dirs $BASEURL/isolinux/isolinux.cfg -o $ISOLINUXDIR/isolinux/isolinux.cfg
curl --create-dirs $BASEURL/isolinux/memtest -o $ISOLINUXDIR/isolinux/memtest
curl --create-dirs $BASEURL/isolinux/splash.png -o $ISOLINUXDIR/isolinux/splash.png
curl --create-dirs $BASEURL/isolinux/vesamenu.c32 -o $ISOLINUXDIR/isolinux/vesamenu.c32
curl --create-dirs $BASEURL/isolinux/vmlinuz -o $ISOLINUXDIR/isolinux/vmlinuz
curl --create-dirs $BASEURL/images/boot.iso -o $ISOLINUXDIR/images/boot.iso
curl --create-dirs $BASEURL/images/pxeboot/initrd.img -o $ISOLINUXDIR/images/pxeboot/initrd.img
curl --create-dirs $BASEURL/images/pxeboot/vmlinuz -o $ISOLINUXDIR/images/pxeboot/vmlinuz

curl --create-dirs $BASEURL/EFI/BOOT/BOOTIA32.EFI -o $ISOLINUXDIR/EFI/BOOT/BOOTIA32.EFI
curl --create-dirs $BASEURL/EFI/BOOT/BOOTX64.EFI -o $ISOLINUXDIR/EFI/BOOT/BOOTX64.EFI
curl --create-dirs $BASEURL/EFI/BOOT/grubia32.efi -o $ISOLINUXDIR/EFI/BOOT/grubia32.efi
curl --create-dirs $BASEURL/EFI/BOOT/grubx64.efi -o $ISOLINUXDIR/EFI/BOOT/grubx64.efi
curl --create-dirs $BASEURL/EFI/BOOT/mmia32.efi -o $ISOLINUXDIR/EFI/BOOT/mmia32.efi
curl --create-dirs $BASEURL/EFI/BOOT/mmx64.efi -o $ISOLINUXDIR/EFI/BOOT/mmx64.efi
curl --create-dirs $BASEURL/EFI/BOOT/fonts/unicode.pf2  -o $ISOLINUXDIR/EFI/BOOT/unicode.pf2

mkdir -p $ISOLINUXDIR/EXTRAS/kickstart-menu
cp -r ../kickstart-menu/{classes.py,jinja2,kickstart.py,kickstarts,markupsafe,menu.py,npyscreen} $ISOLINUXDIR/EXTRAS/kickstart-menu
cp -r ../kickstart-menu/kickstarts/* $ISOLINUXDIR/ks
cp -f ./isolinux.cfg $ISOLINUXDIR/isolinux
#mount -o loop $ISOLINUXDIR/images/efiboot.img $ISOLINUXDIR/EFI
#mount $ISOLINUXDIR/images/efiboot.img $ISOLINUXDIR/EFI
mkdosfs -n ANACONDA -R 1 -S 512 -C $ISOLINUXDIR/images/efiboot.img 9008
mcopy -i $ISOLINUXDIR/images/efiboot.img -s $ISOLINUXDIR/EFI ::/
mcopy -D o -i $ISOLINUXDIR/images/efiboot.img ./grub.cfg ::/EFI/BOOT/
cp -f ./grub.cfg $ISOLINUXDIR/EFI/BOOT
mkdir -p $ISOLINUXDIR/EXTRAS/{firstboot,nginx,kubernetes}
cp ../pxeboot/default $ISOLINUXDIR/EXTRAS/
cp ../firstboot/firstboot.sh $ISOLINUXDIR/EXTRAS/firstboot
cp ../webserver/*.conf $ISOLINUXDIR/EXTRAS/nginx
cp -r ../kubernetes/* $ISOLINUXDIR/EXTRAS/kubernetes/

yumdownloader --archlist=x86_64 -x \*i686 --destdir=$ISOLINUXDIR/Packages --resolve --disablerepo=\* --enablerepo=base --enablerepo=updates --enablerepo=edcop --enablerepo=edcop-extras --enablerepo=epel --enablerepo=extras acl aic94xx-firmware alsa-firmware alsa-lib alsa-tools-firmware audit audit-libs audit-libs-python augeas-libs authconfig autogen-libopts avahi-libs basesystem bash bind-libs-lite bind-license binutils biosdevname boost-system boost-thread bridge-utils btrfs-progs bzip2 bzip2-libs ca-certificates centos-logos centos-release checkpolicy chkconfig chrony container-selinux coreutils cpio cpp cracklib cracklib-dicts cronie cronie-anacron crontabs cryptsetup cryptsetup-libs curl cyrus-sasl cyrus-sasl-gssapi cyrus-sasl-lib dbus dbus-glib dbus-libs dbus-python device-mapper device-mapper-event device-mapper-event-libs device-mapper-libs device-mapper-multipath device-mapper-multipath-libs device-mapper-persistent-data dhclient dhcp-common dhcp-libs diffutils dmidecode dnsmasq docker dosfstools dracut dracut-config-rescue dracut-network e2fsprogs e2fsprogs-libs ebtables edcop-repo elfutils-default-yama-scope elfutils-libelf elfutils-libs epel-release ethtool expat file file-libs filesystem findutils fipscheck fipscheck-lib firewalld firewalld-filesystem fontconfig fontpackages-filesystem freetype fuse fuse-libs fxload gawk gcc gd gdbm gdisk GeoIP gettext gettext-libs git glib2 glibc glibc-common glibc-devel glibc-headers glib-networking glusterfs glusterfs-api glusterfs-cli glusterfs-client-xlators glusterfs-libs gmp gnupg2 gnutls gnutls-dane gnutls-utils gobject-introspection golang golang-bin golang-src gperftools-libs gpgme gpm-libs grep groff-base grub2 grub2-common grub2-pc grub2-pc-modules grub2-tools grub2-tools-extra grub2-tools-minimal grubby gsettings-desktop-schemas gssproxy gzip hardlink hostname hwdata info initscripts iproute iprutils ipset ipset-libs iptables iputils irqbalance iscsi-initiator-utils iscsi-initiator-utils-iscsiuio ivtv-firmware iwl1000-firmware iwl100-firmware iwl105-firmware iwl135-firmware iwl2000-firmware iwl2030-firmware iwl3160-firmware iwl3945-firmware iwl4965-firmware iwl5000-firmware iwl5150-firmware iwl6000-firmware iwl6000g2a-firmware iwl6000g2b-firmware iwl6050-firmware iwl7260-firmware iwl7265-firmware jansson jq json-glib kbd kbd-legacy kbd-misc kernel kernel-headers kernel-tools kernel-tools-libs kexec-tools keyutils keyutils-libs kmod kmod-libs kpartx krb5-libs kubeadm kubectl kubelet kubernetes-cni ldns less libacl libaio libassuan libatasmart libattr libbasicobjects libblkid libcap libcap-ng libcgroup libcollection libcom_err libcroco libcurl libdaemon libdb libdb-utils libdnet libdrm libedit libestr libevent libfastjson libffi libgcc libgcrypt libgnome-keyring libgomp libgpg-error libgudev1 libicu libidn libini_config libiscsi libjpeg-turbo libmnl libmodman libmount libmpc libmspack libndp libnetfilter_conntrack libnfnetlink libnfsidmap libnl3 libnl3-cli libpath_utils libpcap libpciaccess libpipeline libpng libproxy libpwquality librados2 librbd1 libref_array libreport-filesystem libseccomp libselinux libselinux-python libselinux-utils libsemanage libsemanage-python libsepol libss libssh libssh2 libstdc++ libstoraged libsysfs libtasn1 libteam libtirpc libtool-ltdl libunistring libunwind libuser libutempter libuuid libverto libverto-libevent libvirt libvirt-client libvirt-daemon libvirt-daemon-config-network libvirt-daemon-config-nwfilter libvirt-daemon-driver-interface libvirt-daemon-driver-lxc libvirt-daemon-driver-network libvirt-daemon-driver-nodedev libvirt-daemon-driver-nwfilter libvirt-daemon-driver-qemu libvirt-daemon-driver-secret libvirt-daemon-driver-storage libvirt-daemon-driver-storage-core libvirt-daemon-driver-storage-disk libvirt-daemon-driver-storage-gluster libvirt-daemon-driver-storage-iscsi libvirt-daemon-driver-storage-logical libvirt-daemon-driver-storage-mpath libvirt-daemon-driver-storage-rbd libvirt-daemon-driver-storage-scsi libvirt-libs libX11 libX11-common libXau libxcb libxml2 libxml2-python libXpm libxslt linux-firmware logrotate lsscsi lua lvm2 lvm2-libs lyx-fonts lzo lzop make man-db mariadb-libs mdadm microcode_ctl mlocate mozjs17 mpfr mtools ncurses ncurses-base ncurses-libs netcf-libs nettle net-tools NetworkManager NetworkManager-libnm NetworkManager-team NetworkManager-tui NetworkManager-wifi newt newt-python nfs-utils nginx nginx-all-modules nginx-filesystem nginx-mod-http-geoip nginx-mod-http-image-filter nginx-mod-http-perl nginx-mod-http-xslt-filter nginx-mod-mail nginx-mod-stream nmap-ncat nspr nss nss-pem nss-softokn nss-softokn-freebl nss-sysinit nss-tools nss-util numactl-libs numad oniguruma openldap openscap openscap-scanner openssh openssh-clients openssh-server openssl openssl-libs open-vm-tools os-prober p11-kit p11-kit-trust PackageKit PackageKit-glib PackageKit-yum pam parted passwd pciutils pciutils-libs pcre perl perl-Carp perl-constant perl-Encode perl-Error perl-Exporter perl-File-Path perl-File-Temp perl-Filter perl-Getopt-Long perl-Git perl-HTTP-Tiny perl-libs perl-macros perl-parent perl-PathTools perl-Pod-Escapes perl-podlators perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Storable perl-TermReadKey perl-Text-ParseWords perl-threads perl-threads-shared perl-Time-HiRes perl-Time-Local pinentry pkgconfig plymouth plymouth-core-libs plymouth-scripts policycoreutils policycoreutils-python polkit polkit-pkla-compat popt postfix procps-ng pth pygobject2 pygpgme pyliblzma python python-chardet python-configobj python-decorator python-firewall python-gobject-base python-iniparse python-IPy python-kitchen python-libs python-linux-procfs python-perf python-pycurl python-pyudev python-schedutils python-six python-slip python-slip-dbus python-urlgrabber pyxattr qemu-img qrencode-libs quota quota-nls radvd readline rootfiles rpcbind rpm rpm-build-libs rpm-libs rpm-python rsync rsyslog scap-security-guide sed selinux-policy selinux-policy-targeted setools-libs setup shadow-utils shared-mime-info slang snappy socat sqlite storaged storaged-iscsi storaged-lvm2 sudo syslinux systemd systemd-libs systemd-sysv sysvinit-tools tar tcp_wrappers tcp_wrappers-libs teamd trousers tuned tzdata unbound-libs ustr util-linux vim-common vim-enhanced vim-filesystem vim-minimal virt-what wget which wpa_supplicant xfsprogs xml-common xmlsec1 xmlsec1-openssl xz xz-libs yajl yum yum-metadata-parser yum-plugin-fastestmirror yum-utils zlib virt-viewer edcop-virtctl edcop-helm nfs-utils grub2-efi-x64 shim-x64 efibootmgr pango
