@echo off
set MYDOTFILES=%~dp0

luarocks --lua-version=5.1 --local install vusted

set PATH=%APPDATA%/LuaRocks/bin;C:\tools\neovim\nvim-win64\bin;%PATH%
for /f "delims=" %%i in ('luarocks --lua-version=5.1 --local path') do %%i
echo PATH: %PATH%
echo LUA_PATH: %LUA_PATH%
echo LUA_CPATH: %LUA_CPATH%

set VUSTED_ARGS=--headless
set VUSTED_USE_LOCAL=1
call vusted --shuffle

exit /B %ERRORLEVEL%
