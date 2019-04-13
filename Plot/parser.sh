#!/bin/bash




#run with sudo





htmlDir=`pwd`




cd ../Logs/New/
for dir in */; do
	cd $dir
	for tDir in */; do
		cd $tDir
		for ttDir in */; do
			cd $ttDir
			cp $htmlDir/New/*.html .
			for i in ./p_irq*.csv;do
				 val=`echo $i|cut -c 8-9`;
				 cp irq.html irq$val.html
				 sudo sed -i 's/IRQ/IRQ'$val'/' irq$val.html
				 sudo sed -i 's/p_irq.csv/p_irq'$val'.csv/' irq$val.html
			done
			sudo mkdir -p /var/www/html/Plot/New/$dir/$tDir/$ttDir/
			sudo cp *.html /var/www/html/Plot/New/$dir/$tDir/$ttDir/
			sudo cp p_*.csv /var/www/html/Plot/New/$dir/$tDir/$ttDir/
			cd ..
		done
		cd ..
	done
	cd ..
done
cd ../../Plot



cd ../Logs/Phy_VM_rand/
for dir in */; do
	cd $dir
	for tDir in */; do
		cd $tDir
			cp $htmlDir/Old/*.html .
			for i in ./p_irq*.csv;do
				 val=`echo $i|cut -c 8-9`;
				 cp irq.html irq$val.html
				 sudo sed -i 's/IRQ/IRQ'$val'/' irq$val.html
				 sudo sed -i 's/p_irq.csv/p_irq'$val'.csv/' irq$val.html
			done
			sudo mkdir -p /var/www/html/Plot/Phy_VM_rand/$dir/$tDir/
			sudo cp *.html /var/www/html/Plot/Phy_VM_rand/$dir/$tDir/
			sudo cp p_*.csv /var/www/html/Plot/Phy_VM_rand/$dir/$tDir/
		cd ..
	done
	cd ..
done
cd ../../Plot



















cd ../Logs/MKS
cp $htmlDir/New/*.html .
for i in ./p_irq*.csv;do
	 val=`echo $i|cut -c 8-9`;
	 cp irq.html irq$val.html
	 sudo sed -i 's/IRQ/IRQ'$val'/' irq$val.html
	 sudo sed -i 's/p_irq.csv/p_irq'$val'.csv/' irq$val.html
done
cp irq.html xfer.html
sudo sed -i 's/IRQ/xfer/' xfer.html
sudo sed -i 's/p_irq.csv/p_xfer.csv/' xfer.html
sudo mkdir -p /var/www/html/Plot/MKS
sudo cp *.html /var/www/html/Plot/MKS
sudo cp p_*.csv /var/www/html/Plot/MKS
cd ../../Plot



cd ../Logs/Quiet_ASLR_ramdisk
cp $htmlDir/New/*.html .
for i in ./p_irq*.csv;do
	 val=`echo $i|cut -c 8-9`;
	 cp irq.html irq$val.html
	 sudo sed -i 's/IRQ/IRQ'$val'/' irq$val.html
	 sudo sed -i 's/p_irq.csv/p_irq'$val'.csv/' irq$val.html
done
cp irq.html xfer.html
sudo sed -i 's/IRQ/xfer/' xfer.html
sudo sed -i 's/p_irq.csv/p_xfer.csv/' xfer.html
sudo mkdir -p /var/www/html/Plot/Quiet_ASLR_ramdisk
sudo cp *.html /var/www/html/Plot/Quiet_ASLR_ramdisk
sudo cp p_*.csv /var/www/html/Plot/Quiet_ASLR_ramdisk
cd ../../Plot
