@echo off
setlocal enabledelayedexpansion

rem set default config
set "default_platform=x64"
set "default_configuration=Debug"
set "default_version=1.0.0"
set "default_forceupdate=no"

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

rem check forceupdate validation
set "valid_forceupdate=yes no"
set "forceupdate=%4"
if not defined forceupdate set "forceupdate=%default_forceupdate%"
if "%valid_forceupdate%" equ "!valid_forceupdate:*%forceupdate%=!" (
    echo invalid forceupdate:%forceupdate%, use default:%default_forceupdate%
    set "forceupdate=%default_forceupdate%"
)

echo platform:%platform%
echo configuration:%configuration%
echo version:%version%
echo forceupdate:%forceupdate%

set domain=www.riskfree.com.cn

echo Start to upload the Setup file
icacls stage_instrument_rsa /inheritance:r /grant:r "%username%:R"
scp -i stage_instrument_rsa Build\WiX\%configuration%\%platform%\StageInstrument-%version%-%platform%-Setup.msi root@%domain%:/ && (
    echo SCP operation successful
) || (
    echo SCP operation failed
    goto :eof
)

rem ping the domain
for /f "tokens=3" %%a in ('ping -n 1 %domain% ^| findstr "Pinging"') do (
    set input=%%a
)

rem extra ip
set ip=!input:~1,-1!

if defined ip (
    echo Server IP address is !ip!
) else (
    echo Unable to retrieve IP address.
	goto :eof
)

echo update the version info in server
curl -X POST -F "Version=%version%" -F "ForceUpdate=%forceupdate%" http://!ip!:8080/update
