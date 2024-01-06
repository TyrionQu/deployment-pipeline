rem @echo off
rem set Visual Studio build env
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
set "default_platform=x64"
set "default_configuration=Debug"
set "default_delete=nop"

rem check platform validation
set "valid_platforms=x86 x64"
set "platform=%1"
if not defined platform set "platform=%default_platform%"
if not "%valid_platforms%" equ "%valid_platforms:*%platform%=%" (
    echo invalid platform：%platform%，use default：%default_platform%
    set "platform=%default_platform%"
)

rem check platform validation
set "valid_configurations=Debug Release"
set "configuration=%2"
if not defined configuration set "configuration=%default_configuration%"
if not "%valid_configurations%" equ "%valid_configurations:*%configuration%=%" (
    echo invalid platform：%configuration%，use default：%default_configuration%
    set "configuration=%default_configuration%"
)

rem check delete folder validation
set "deleteFolder=%3"
if not defined deleteFolder set "deleteFolder=%default_delete%"
if /i "%deleteFolder%"=="delete" (
	echo Deleting folders...
	rmdir /s /q dependencies
	echo Folders deleted successfully.
)

echo platform：%platform%
echo configuration：%configuration%
echo deleteFolder：%deleteFolder%


pushd "%~dp0"
rem download dependencies using git
git clone https://github.com/TyrionQu/dependencies.git
pushd dependencies
git pull
rem download submodules in dependencies
git submodule update --init --recursive 

echo opencv building start!!
rem build opencv
pushd opencv
mkdir build
pushd build
rem cmake -G "Visual Studio 17 2022" -A %platform% -DCMAKE_BUILD_TYPE=%configuration% -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF ..
rem msbuild /m ALL_BUILD.vcxproj /p:Platform=%platform% /p:Configuration=%configuration%
cmake -G "Visual Studio 17 2022" -A %platform% -DCMAKE_BUILD_TYPE=%configuration% -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_opencv_world=ON ..
msbuild /m ALL_BUILD.vcxproj /p:Platform=%platform% /p:Configuration=%configuration%
popd
popd
echo opencv building end!!


echo wingup building start!!
rem build winup
pushd wingup
call curl\buildconf.bat
pushd curl\winbuild
call nmake /f Makefile.vc mode=dll vc=15 RTLIBCFG=static MACHINE=%platform%
if %errorlevel% neq 0 goto :eof 
popd
pushd vcproj
rem libcurl.dll and GUP.exe are created in bin64
msbuild /m GUP.vcxproj /p:Configuration=Release /p:WindowsTargetPlatformVersion=10.0 /p:PlatformToolset=v143 /p:Platform=%platform%
if %errorlevel% neq 0 goto :eof 
popd
popd
echo wingup building end!!


popd
popd
