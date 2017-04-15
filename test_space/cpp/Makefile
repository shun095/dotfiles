# shelltest: shellcpptest.cpp test
# 	g++ -o shelltest shellcpptest.cpp
test: test.cpp
	clang++ -isystem /mingw64/include/ -isystem /mingw64/include/c++/6.2.0 -o test test.cpp
clean:
	rm -f shelltest
	rm -f test

