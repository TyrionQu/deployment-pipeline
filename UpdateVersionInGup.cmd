@echo off
setlocal enabledelayedexpansion

rem set default config
set "default_version=1.0.0"

rem check version
set "version=%1"
if not defined version set "version=%default_version%"

echo update version in gup.xml:%version%

rem update version in gup.xml
powershell -Command "(Get-Content 'dependencies\wingup\bin64\gup.xml') -replace '<Version>.*</Version>', '<Version>%version%</Version>' | Set-Content 'dependencies\wingup\bin64\gup.xml'"
