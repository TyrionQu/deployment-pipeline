## Build Requirements

### Visual Studio 2022

 * *Community*, *Professional* or *Enterprise* Edition
 * MSVC v143 Buildtools (x64/x86, ARM, ARM64)
 * C++ MFC for latest v143 build tools (x64/x86, ARM, ARM64)
 * C++ ATL for latest v143 build tools (x64/x86, ARM, ARM64)
 * Windows 10 SDK
 
### Other utilities/programs

 * git
 * WiX v3.11
 * cmake

## How to Build

~~~
BuildAll.cmd [x86|x64] [Debug|Release] [version] [delete|nop] [yes|no]
~~~

### param indication
 * x86|x64 indicates build platform
 * Debug|Release indicates build configuration
 * version indicates build version, the format is like 1.0.0
 * delete means delete depencies and main exe source folder, nop means do nothing
 * yes|no is a forced upgrade required