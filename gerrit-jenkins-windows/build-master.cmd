@echo off
setlocal

set GERRIT=%1
set BRANCH=%2
set BUILDALL=%3

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat" 
fullbuild init git %GERRIT%full-build .
fullbuild clone --mt --shallow * || goto :failure
fullbuild history --html || goto :failure
fullbuild install || goto :failure
if "%BUILDALL%" == "true" (
    fullbuild view wks * || goto :failure
) else (
    fullbuild pull --bin || goto :failure
    fullbuild view --modified --up wks || goto :failure
)
fullbuild build --version 1.0.%BUILD_NUMBER%.0 wks || goto :failure
fullbuild test wks || goto :failure
fullbuild publish --mt * || goto :failure
if "%BUILDALL%" == "true" (
    fullbuild push --all --branch %BRANCH% %BUILD_NUMBER% || goto :failure
) else (
    fullbuild push --branch %BRANCH% %BUILD_NUMBER% || goto :failure
)

:success
echo ***** SUCCESS *****
exit 0

:failure
echo ***** FAILURE *****
exit 5
