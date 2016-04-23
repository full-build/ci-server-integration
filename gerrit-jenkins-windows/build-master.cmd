@echo off
setlocal

set GERRIT=%1

echo ==[vsdevcmd]==== %TIME% ======
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat" 

echo ==[init]==== %TIME% ======
fullbuild init git %GERRIT%full-build .

echo ==[clone]==== %TIME% ======
fullbuild clone --shallow * || goto :failure

echo ==[history]==== %TIME% ======
fullbuild history > history || goto :failure

echo ==[install]==== %TIME% ======
fullbuild install || goto :failure

echo ==[view]==== %TIME% ======
fullbuild view wks * || goto :failure

echo ==[build]==== %TIME% ======
fullbuild build --version 1.0.%BUILD_NUMBER%.0 wks || goto :failure

echo ==[test]==== %TIME% ======
fullbuild test --exclude Integration * || goto :failure

echo ==[publish]==== %TIME% ======
fullbuild publish * || goto :failure

echo ==[push]==== %TIME% ======
fullbuild push %BUILD_NUMBER% || goto :failure

echo ==[done]==== %TIME% ======

:success
echo ***** SUCCESS *****
exit 0

:failure
echo ***** FAILURE *****
exit 5
