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
if not exist %HERE%%REPO% goto :success_not_fb

pushd %REPO% || goto :failure
set FB_BRANCH=
for /F "tokens=*" %%F in ('git branch') do if "%%F"=="* %BRANCH%" set FB_BRANCH=%BRANCH%
git fetch %GERRIT%%REPO% %REFSPEC% && git checkout FETCH_HEAD || goto :failure
popd || goto :failure

if not "%FB_BRANCH%"=="%BRANCH%" goto :success_not_fb_branch

fullbuild history > history || goto :failure
fullbuild install || goto :failure
fullbuild pull --bin || goto :failure
fullbuild view wks %REPO%/* || goto :failure
fullbuild build wks || goto :failure
fullbuild test --exclude Integration %REPO%/* || goto :failure

:success
echo ***** SUCCESS *****
exit /b 0

:failure
echo ***** FAILURE *****
exit /b 5

:success_not_fb
echo ***** SUCCESS (NOT MANAGED BY FULLBUILD) *****
exit /b 0

:success_not_fb_branch
echo ***** SUCCESS (FULLBUILD BUT NOT MANAGED BRANCH) *****
exit /b 0
