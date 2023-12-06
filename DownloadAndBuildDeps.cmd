@echo off
rem set Visual Studio build env
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"


pushd "%~dp0"
rem download dependencies using git
git clone https://github.com/TyrionQu/dependencies.git
pushd dependencies
rem download submodules in dependencies
git submodule update --init --recursive 

rem build cpython
pushd cpython
rem python*.dll is created in PCbuild/amd64/
PCbuild\build.bat
popd

rem build curl
pushd curl
call buildconf.bat
pushd winbuild
rem libcurl.dll is created in /builds/libcurl-vc-x64-release-dll-ipv6-sspi-schannel/bin/libcurl.dll
call nmake /f Makefile.vc mode=dll RTLIBCFG=static MACHINE=x64
popd
popd




popd
popd