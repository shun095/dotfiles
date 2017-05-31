@echo off

set /p python3_dir="Python3のディレクトリ："
set /p boost_dir="Boostのディレクトリ："

pushd %USERPROFILE%\.vim\dein\repos\github.com\nixprime\cpsm\
del /s/q CMakeFiles CMakeCache.txt
cmake CMakeLists.txt -G "MinGW Makefiles" ^
-DPYTHON_EXECUTABLE=%python3_dir%\python.exe ^
-DPYTHON_LIBRARIES=%python3_dir%\libs\python36.lib ^
-DBOOST_ROOT=%boost_dir%

if not "%ERRORLEVEL%"  == "0" (
    echo 失敗したよん
) else (

    mingw32-make
    del /s/q autoload\cpsm_cli.exe autoload\cpsm_py.pyd
    copy cpsm_cli.exe autoload\
    copy cpsm_py.dll autoload\cpsm_py.pyd
    mkdir bin
    copy cpsm_cli.exe bin\
    copy cpsm_py.dll bin\cpsm_py.pyd
    copy cpsm_py.dll bin\cpsm_py.so
)

popd
pause


