#!/bin/bash
yum install wget
WEB="http://debuginfo.centos.org/7/x86_64/" #Update the link appropriately as Cent OS version change
RELEASE=`uname -r`
MACHINE=`uname -m`
PKG1="kernel-debuginfo-$RELEASE.rpm"
PKG2="kernel-debuginfo-common-$MACHINE-$RELEASE.rpm"
wget $WEB$PKG1
wget $WEB$PKG2
#Build Downloaded debuginfo packages
rpm -Uhv kernel-debuginfo-*.rpm
#Install systemtap and kernel-developemnt packages
yum install kernel-devel-$RELEASE
yum install systemtap gcc