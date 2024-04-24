#! /bin/bash

project_path=$1
result_dir=$2

cd ..
beremizDir=$(cd "$(dirname "$0")"; pwd)

# matiec macro dependency (need)
iec_include="${beremizDir}/matiec/lib/C"

# modbus module (need)
modbus_lib="${beremizDir}/Modbus"

# softplc_socket module (need)
socket_lib="${beremizDir}/Socket"


cd $project_path

if [ "$(find . -maxdepth 1 -type d | grep "./${result_dir}")" != "./${result_dir}" ]; then
    mkdir ${result_dir}
else
    rm "./${result_dir}"/*
fi

for file in *.c;do
    c_file_name=${file%.*}
    gcc -E $file "-I${iec_include}" "-I${modbus_lib}" "-I${socket_lib}" -Wno-unused-function -o "./${result_dir}/${c_file_name}.c"
done

