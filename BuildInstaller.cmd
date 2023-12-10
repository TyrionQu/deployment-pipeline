@echo off
rem set Visual Studio build env
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

set "default_platform=x64"
set "default_configuration=Debug"

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

echo platform：%platform%
echo configuration：%configuration%

pushd "%~dp0"
pushd Installer\WixInstaller
rem msbuild /m StageInstrument.wixproj /p:Platform=%platform% /p:Configuration=%configuration% /p:ProductVersion=1.0.0
msbuild /m StageInstrument.wixproj /p:Platform=%platform% /p:Configuration=%configuration%
popd
popd
