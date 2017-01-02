#!/bin/bash

# stop on error
set -e
############################################
# install s3fs
sudo apt-get update
sudo apt-get install -y automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config
sudo apt-get install git
git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse
./autogen.sh
./configure
make
sudo make install

cd ~/
echo AKIAICDS6KM4FJIZV7FQ:3fRVoPUN+OEwnuPmAjLMJQmLDpCCDHk73JkgQXkj > .passwd-s3fs
chmod 600 .passwd-s3fs
mkdir s3mnt
mkdir /tmp/cache
chmod 777 s3mnt /tmp/cache
s3fs imagenet-sophon s3mnt -o use_cache=/tmp/cache

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y build-essential git python-pip libfreetype6-dev libxft-dev libncurses-dev libopenblas-dev gfortran python-matplotlib libblas-dev liblapack-dev libatlas-base-dev python-dev python-pydot linux-headers-generic linux-image-extra-virtual unzip python-numpy swig python-pandas python-sklearn unzip wget pkg-config zip g++ zlib1g-dev libcurl3-dev
sudo pip install -U pip

# install cuda8
wget https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda-repo-ubuntu1604-8-0-local_8.0.44-1_amd64-deb
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local_8.0.44-1_amd64-deb
rm cuda-repo-ubuntu1604-8-0-local_8.0.44-1_amd64-deb
sudo apt-get update
sudo apt-get install -y cuda

# install cudnn
sudo dpkg -i libcudnn5_5.1.5-1+cuda8.0_amd64.deb
sudo dpkg -i libcudnn5-dev_5.1.5-1+cuda8.0_amd64.deb

#installl bazel (optional)
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
# Hack to silently agree license agreement
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
curl https://storage.googleapis.com/bazel-apt/doc/apt-key.pub.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install bazel
sudo apt-get upgrade bazel

# install monitoring programs
sudo wget https://git.io/gpustat.py -O /usr/local/bin/gpustat
sudo chmod +x /usr/local/bin/gpustat
sudo nvidia-smi daemon
sudo apt-get -y install htop

#install tensorflow
sudo apt-get install -y python-pip python-dev python-virtualenv
virtualenv --system-site-packages ~/tensorflow
source ~/tensorflow/bin/activate
export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-0.12.0rc1-cp27-none-linux_x86_64.whl
pip install --upgrade $TF_BINARY_URL
sudo apt-get install build-essential gfortran libatlas-base-dev python-pip python-dev
pip install --upgrade scipy
sudo apt-get install libjpeg-dev libfreetype6 libfreetype6-dev zlib1g-dev
pip install Pillow
git clone https://github.com/tensorflow/magenta.git

# reload .bashrc
exec bash
############################################
# run the test
# byobu				# start byobu + press Ctrl + F2 
# htop				# run in window 1, press Shift + F2
# watch --color -n1.0 gpustat -cp	# run in window 2, press Shift + <left>
# wget https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/models/image/mnist/convolutional.py
# python convolutional.py		# run in window 3
