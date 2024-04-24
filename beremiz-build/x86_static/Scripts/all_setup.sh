#! /bin/bash

cd ..
beremizDir=$(cd "$(dirname "$0")"; pwd)

# Prerequisites
sudo apt-get install build-essential bison flex autoconf git curl

# matiec
matiecPath="${beremizDir}/matiec"
cd $matiecPath
autoreconf -i
./configure
make clean
make

# modbus
modbusPath="${beremizDir}/Modbus"
cd $modbusPath
make clean
make