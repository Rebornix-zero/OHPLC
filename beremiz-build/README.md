# Beremiz-build

Project to port beremiz executable file and its dependency to OpenHarmony, which architecture is Linux-aarch64, but without toolchains like glibc, apt and so on.
We only use modbus TCP as communicate protocol.

## Work Environment
- Ubuntu 20.04
- X86 

## Usage
At the `Scripts` directory, run `sh ./all_setup.sh`, `sh ./build_XXX.sh <build path> <excutable name>`.  
\<build path\> is the path of a project's `build` directory.  
\<excutable name\> is the name of executable, which will be put in the `build` path.    
> ex. `sh ./build_XXX.sh  .\Projects\sensor_conveyer\build mybuild_program`  