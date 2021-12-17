@echo off
setlocal
echo Start building cpsm

if "%1" EQU "" (
        set /p python3_dir="Root directory of Python3�F"
        set /p boost_dir="Root directory of Boost�F"
) else (
        set python3_dir=%1
        set boost_dir=%2
)
echo Python_dir: %python3_dir%
echo Boost_dir: %boost_dir%

REM  pushd %USERPROFILE%\.vim\plugged\cpsm\
pushd %USERPROFILE%\.vim\dein\repos\github.com\nixprime\cpsm

set header_flag=false
for /f "usebackq delims=" %%a in (`findstr cmath src\python_extension.cc`) do set header_flag=true

if not "%header_flag%" == "true" (
    echo #include ^<math.h^> > src\tmp.txt
    echo #include ^<cmath^> >> src\tmp.txt
    copy /b src\tmp.txt+src\python_extension.cc src\tmp.txt
    move src\tmp.txt src\python_extension.cc
)

del /s/q CMakeFiles CMakeCache.txt
cmake CMakeLists.txt -G "MinGW Makefiles" ^
REM  cmake CMakeLists.txt ^
-DPYTHON_EXECUTABLE="%python3_dir:"=%\python" ^
-DPYTHON_LIBRARIES="%python3_dir:"=%\libs\python36.lib" ^
-DBOOST_ROOT="%boost_dir:"=%"

if not "%ERRORLEVEL%"  == "0" (
    echo Build failed.
    exit /b
) else (
    mingw32-make
)

if not "%ERRORLEVEL%"  == "0" (
    echo Build failed.
    exit /b
) else (
    del /s/q autoload\cpsm_cli.exe autoload\cpsm_py.pyd
    copy cpsm_cli.exe autoload\
    copy cpsm_py.dll autoload\cpsm_py.pyd
    mkdir bin
    copy cpsm_cli.exe bin\
    copy cpsm_py.dll bin\cpsm_py.pyd
    REM  copy cpsm_py.dll bin\cpsm_py.so
    title >bin\cpsm_py.so
)

popd
