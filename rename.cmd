@echo off
rem Renames this template to your own project.
rem   - renames the solution file to <name>.slnx
rem   - sets author and description in fxmanifest.lua
rem Usage: rename.cmd            (asks for the values)
rem        rename.cmd my-resource "Author" "Description"
setlocal
cd /d "%~dp0"

set "ProjName=%~1"
set "Proj_author=%~2"
set "Proj_description=%~3"
if defined ProjName goto :check

:ask
set "ProjName="
set /a Tries+=1
if %Tries% gtr 5 exit /b 1
set /p "ProjName=Project name: "
if not defined ProjName goto :ask

:check
powershell -NoProfile -Command "if ($env:ProjName -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]*$') { exit 1 }" <nul
if errorlevel 1 (
    echo Invalid name. Use letters, digits, - and _ only, without spaces.
    if "%~1"=="" goto :ask
    exit /b 1
)

if not "%~1"=="" goto :apply
echo Leave author or description empty to keep the current value.
set /p "Proj_author=Author: "
set /p "Proj_description=Description: "

:apply

rem Solution file
for %%f in (*.slnx *.sln) do (
    if /i not "%%~nf"=="%ProjName%" ren "%%f" "%ProjName%%%~xf"
)

rem fxmanifest.lua
powershell -NoProfile -Command "$q=[string][char]39; $m=[IO.File]::ReadAllText('fxmanifest.lua'); foreach ($k in 'author','description') { $v=[Environment]::GetEnvironmentVariable('Proj_'+$k); if ($v) { $v=$v.Replace('\','\\').Replace($q,'\'+$q); $m=[regex]::Replace($m, '(?m)^'+$k+'\s[^\r\n]*', { $k+' '+$q+$v+$q }) } }; [IO.File]::WriteAllText('fxmanifest.lua',$m)" <nul
if errorlevel 1 (
    echo Could not update fxmanifest.lua.
    exit /b 1
)

echo.
echo Done. Solution is now %ProjName%.slnx
echo Name the resource folder on your server "%ProjName%" as well.
if "%~1"=="" pause
