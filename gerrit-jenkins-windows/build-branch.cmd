@echo off
setlocal

set GERRIT=%1
set BRANCH=%2
set BUILDALL=%3

echo ==[tools]==== %TIME% ======
call build\setup-tools.cmd || goto :failure

echo ==[vsdevcmd]==== %TIME% ======
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat" 

echo ==[init]==== %TIME% ======
fullbuild init git %GERRIT%full-build . || goto :failure

echo ==[branch]==== %TIME% ======
fullbuild branch %BRANCH% || goto :failure

echo ==[clone]==== %TIME% ======
fullbuild clone --shallow * || goto :failure

echo ==[sanity check]==== %TIME% ======
fullbuild doctor || goto :failure

echo ==[history]==== %TIME% ======
fullbuild history --html || goto :failure
mkdir htmlreports
move history.html htmlreports >nul

if "%BUILDALL%" EQU "true" (
    set BUILD_VIEW=wks *
    set PUSH_TYPE=--full
) else (
    set BUILD_VIEW=--modified --ref wks
    set PUSH_TYPE=

    echo ==[fetch latest binaries]==== %TIME% ======
    fullbuild pull --bin || goto :failure
)

echo ==[install]==== %TIME% ======
fullbuild install || goto :failure

echo ==[view]==== %TIME% ======
fullbuild view %BUILD_VIEW% || goto :failure

echo ==[build]==== %TIME% ======
fullbuild build --version 1.1.%BUILD_NUMBER%.0 wks || goto :failure

echo ==[test]==== %TIME% ======
fullbuild test wks || goto :failure

echo ==[publish]==== %TIME% ======
fullbuild publish --version 1.1.%BUILD_NUMBER% --view wks * || goto :failure

echo ==[push]==== %TIME% ======
fullbuild push %PUSH_TYPE% %BUILD_NUMBER% || goto :failure

echo ==[done]==== %TIME% ======

:success
echo ***** SUCCESS *****
exit 0

:failure
echo ***** FAILURE *****
exit 5
