wget https://fedorahosted.org/releases/e/l/elfutils/0.160/elfutils-0.160.tar.bz2
wget https://sourceware.org/systemtap/ftp/releases/systemtap-2.7.tar.gz
tar jxf elfutils-0.160.tar.bz2
tar zxf systemtap-2.7.tar.gz
cd systemtap-2.7
./configure --with-elfutils=../elfutils-0.160
make
sudo make install