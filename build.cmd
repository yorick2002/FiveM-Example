@echo off
set RunningBuildScript=true
pushd "%~dp0"

pushd Web
if not exist node_modules (
    call npm ci || goto :webfail
)
call npm run build || goto :webfail
popd

pushd Client
dotnet publish -c Release
popd
pushd Server
dotnet publish -c Release
popd

if exist dist rmdir /s /q dist
mkdir dist
copy /y fxmanifest.lua dist
xcopy /y /e Client\bin\Release\net10.0\publish dist\Client\bin\Release\net10.0\publish\
xcopy /y /e Server\bin\Release\net10.0\publish dist\Server\bin\Release\net10.0\publish\
xcopy /y /e Web\build dist\web\build\

popd
exit /b 0

:webfail
echo Web build failed.
popd
popd
exit /b 1
