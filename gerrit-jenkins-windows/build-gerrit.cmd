@echo off
setlocal

set REPO=%1
set BRANCH=%2
set REFSPEC=%3
set GERRIT=%4

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat" 

echo building repo %REPO% + refspec %REFSPEC%
fullbuild init git %GERRIT%full-build . || goto :failure
fullbuild clone --shallow %REPO%  || goto :failure
fullbuild history --html || goto :failure
fullbuild install || goto :failure
fullbuild pull --bin || goto :failure
fullbuild view wks %REPO%/* || goto :failure
fullbuild build wks || goto :failure
fullbuild test wks || goto :failure

:success
echo ***** SUCCESS *****
exit /b 0

:failure
echo ***** FAILURE *****
exit /b 5
