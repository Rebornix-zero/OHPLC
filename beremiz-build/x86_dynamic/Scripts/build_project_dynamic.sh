#! /bin/bash

project_path=$1
build_name=$2

cd ..
beremizDir=$(cd "$(dirname "$0")"; pwd)

# matiec macro dependency (need)
iec_include="${beremizDir}/matiec/lib/C"

# modbus module (need)
modbus_lib="${beremizDir}/Modbus"

# softplc_socket module (need)
# socket_lib="${beremizDir}/Socket"

object_files=""

# cd $socket_lib
# rm -rf *.o
# for file in *.c;do
#   c_file_name=${file%.*}
#   gcc -c $file -o "${c_file_name}.o" -O2 -fPIC -Wno-unused-function
# done

# for file in *.o;do
#   o="${socket_lib}/${file}"
#   object_files="${object_files} ${o}"
# done


# cd ..
cd $project_path
rm -rf *.o

sed -i "1cchar * PLC_file_name=\"${build_name}\";" ./plc_main.c

for file in *.c;do
    c_file_name=${file%.*}
    if [ $c_file_name = "POUS" ];then
      continue
    fi
    gcc -c $file -o "${c_file_name}.o" -O2 -fPIC "-I${iec_include}" "-I${modbus_lib}" -Wno-unused-function
done

for file in *.o;do
  object_files="${object_files} ${file} "
done

gcc $object_files -o $build_name -lm -lrt -lpthread "-L${modbus_lib}" "${modbus_lib}/libmb.a" "-Wl,-rpath,${modbus_lib}" -lmb