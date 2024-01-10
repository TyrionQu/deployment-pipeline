@echo off
setlocal enabledelayedexpansion

rem set default config
set "default_platform=x64"
set "default_configuration=Debug"
set "default_version=1.0.0"
set "default_forcedupdate=no"

rem check platform validation
set "valid_platforms=x86 x64"
set "platform=%1"
if not defined platform set "platform=%default_platform%"
if not "%valid_platforms%" equ "%valid_platforms:*%platform%=%" (
    echo invalid platform：%platform%，use default：%default_platform%
    set "platform=%default_platform%"
)

rem check configurations validation
set "valid_configurations=Debug Release"
set "configuration=%2"
if not defined configuration set "configuration=%default_configuration%"
if not "%valid_configurations%" equ "%valid_configurations:*%configuration%=%" (
    echo invalid platform：%configuration%，use default：%default_configuration%
    set "configuration=%default_configuration%"
)

rem check version
set "version=%3"
if not defined version set "version=%default_version%"

rem check forcedupdate validation
set "valid_forcedupdate=yes no"
set "forcedupdate=%4"
if not defined forcedupdate set "forcedupdate=%default_forcedupdate%"
if "%valid_forcedupdate%" equ "!valid_forcedupdate:*%forcedupdate%=!" (
    echo invalid forcedupdate:%forcedupdate%, use default:%default_forcedupdate%
    set "forcedupdate=%default_forcedupdate%"
)

echo platform:%platform%
echo configuration:%configuration%
echo version:%version%
echo forcedupdate:%forcedupdate%

echo upload the Setup file
icacls stage_instrument_rsa /inheritance:r /grant:r "%username%:R"
scp -i stage_instrument_rsa Build\WiX\%configuration%\%platform%\StageInstrument-%version%-%platform%-Setup.msi root@121.40.148.40:/

echo update the version info in server
curl -X POST -F "Version=%version%" -F "ForcedUpdate=%forcedupdate%" http://121.40.148.40:8080/update
