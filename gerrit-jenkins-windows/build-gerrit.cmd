@echo off
setlocal

set REPO=%1
set BRANCH=%2
set REFSPEC=%3
set GERRIT=%4

echo Branch is %BRANCH%
echo building repo %REPO% + refspec %REFSPEC%

echo ==[tools]==== %TIME% ======
call build\setup-tools.cmd

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat" 

echo ==[init]==== %TIME% ======
fullbuild init git %GERRIT%full-build . || goto :failure

echo ==[branch]==== %TIME% ======
fullbuild branch %BRANCH% || goto :failure

echo ==[clone]==== %TIME% ======
fullbuild clone --shallow %REPO%  || goto :failure

echo ==[fetch patch]==== %TIME% ======
pushd %REPO% || goto :failure
git pull --no-commit --ff-only %GERRIT%%REPO% %REFSPEC% || goto :failure
popd || goto :failure

echo ==[init]==== %TIME% ======
fullbuild install || goto :failure

echo ==[history]==== %TIME% ======
fullbuild history --html || goto :failure

echo ==[convert check]==== %TIME% ======
fullbuild convert --check %REPO% || goto :failure

echo ==[view]==== %TIME% ======
fullbuild view wks %REPO%/* || goto :failure

echo ==[build]==== %TIME% ======
fullbuild build wks || goto :failure

echo ==[test]==== %TIME% ======
fullbuild test wks || goto :failure

echo ==[done]==== %TIME% ======

:success
echo ***** SUCCESS *****
exit /b 0

:failure
echo ***** FAILURE *****
exit /b 5
