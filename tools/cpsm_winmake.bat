@echo off

del /s/q CMakeFiles CMakeCache.txt
cmake CMakeLists.txt -G "MinGW Makefiles" ^
-DPYTHON_EXECUTABLE=%1\python.exe ^
-DPYTHON_LIBRARIES=%1\libs\python36.lib ^
-DBOOST_ROOT=%2
