@echo off
setlocal enabledelayedexpansion

rem set default config
set "default_platform=x64"
set "default_configuration=Debug"
set "default_version=1.0.0"
set "default_delete=nop"
set "default_forcedupdate=no"

rem check platform validation
set "valid_platforms=x86 x64"
set "platform=%1"
if not defined platform set "platform=%default_platform%"
if not "%valid_platforms%" equ "%valid_platforms:*%platform%=%" (
    echo invalid platform:%platform%, use default:%default_platform%
    set "platform=%default_platform%"
)

rem check platform validation
set "valid_configurations=Debug Release"
set "configuration=%2"
if not defined configuration set "configuration=%default_configuration%"
if not "%valid_configurations%" equ "%valid_configurations:*%configuration%=%" (
    echo invalid platform:%configuration%, use default:%default_configuration%
    set "configuration=%default_configuration%"
)

rem check version
set "version=%3"
if not defined version set "version=%default_version%"

rem check delete folder validation
set "deleteFolder=%4"
if not defined deleteFolder set "deleteFolder=%default_delete%"
if /i "%deleteFolder%"=="delete" (
	echo Deleting folders...
	rmdir /s /q dependencies
	rmdir /s /q StageInstrument
	echo Folders deleted successfully.
)

rem check forcedupdate validation
set "valid_forcedupdate=yes no"
set "forcedupdate=%5"
if not defined forcedupdate set "forcedupdate=%default_forcedupdate%"
if "%valid_forcedupdate%" equ "!valid_forcedupdate:*%forcedupdate%=!" (
    echo invalid forcedupdate:%forcedupdate%, use default:%default_forcedupdate%
    set "forcedupdate=%default_forcedupdate%"
)

echo platform:%platform%
echo configuration:%configuration%
echo version:%version%
echo deleteFolder:%deleteFolder%
echo forcedupdate:%forcedupdate%

rem record start time
set "start_time=!TIME!"

call DownloadAndBuildDeps.cmd %platform% %configuration% %deleteFolder% || goto :eof
call UpdateVersionInGup.cmd %version% || goto :eof
call DownloadAndBuildExe.cmd %platform% %configuration% %deleteFolder% || goto :eof
call BuildInstaller.cmd %platform% %configuration% %version% || goto :eof
call UploadInstaller.cmd %platform% %configuration% %version% %forcedupdate%

rem record stop time
set "end_time=!TIME!"
echo Start Time: %start_time%
echo End Time  : %end_time%
