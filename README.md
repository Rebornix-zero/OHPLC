# OHPLC

> author: Haocheng Wang

## Brief
OHPLC is a project aimed to porting softplc programs to OpenHarmony, whose architecture is ARM64.  
Anyway, we develop an app/frontend and backend to make user can conveniently manage softplc programs on OpenHarmony.

## Modules
- OHPLC.app: the frontend of the project, which can manage local user, check softplc status, and connect with other OpenHarmony devices.  
- beremiz-build: the projects including build dependency and scripts, can cross-compiling ARM64 softplc programs on a Linux x86 platform.