@echo off
set MYDOTFILES=%~dp0

dir
dir %USERPROFILE%
dir %USERPROFILE%/.config/nvim/

for /f "delims=" %%i in ('luarocks --lua-version=5.1 --local path') do %%i
echo PATH: %PATH%
echo LUA_PATH: %LUA_PATH%
echo LUA_CPATH: %LUA_CPATH%

set VUSTED_ARGS=--headless

call vusted --shuffle

exit /B %ERRORLEVEL%
