@echo off
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
	rmdir /s /q StageInstrument
	echo Folders deleted successfully.
)

echo platform：%platform%
echo configuration：%configuration%
echo deleteFolder：%deleteFolder%

pushd "%~dp0"
rem download StageInstrument using git
git clone https://github.com/TyrionQu/StageInstrument.git
git pull
pushd StageInstrument
msbuild /m StageInstrument.vcxproj /p:Platform=%platform% /p:Configuration=%configuration%
popd
popd