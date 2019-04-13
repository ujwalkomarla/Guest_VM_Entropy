sudo apt-get install dpkg-dev debhelper gawk
mkdir tmp
cd tmp
sudo apt-get build-dep --no-install-recommends linux-image-$(uname -r) #Choose the kernel version you want to develop for. Current: uname -r; Else: Replace it with required kernel
apt-get source linux-image-$(uname -r)
cd linux* 
fakeroot debian/rules clean
AUTOBUILD=1 fakeroot debian/rules binary-generic skipdbg=false
sudo dpkg -i ../linux-image-*.ddeb