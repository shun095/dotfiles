#include <iostream>
#include <cstdio>
#include <unistd.h>

int func(int a){
	for(int func=0 ; func < 10; func++){
		std::cout << "this is func var" << func << std::endl;
	}
	return a+10;
}

int main(void){
	std::cout << "Start debuging\n";
	int i[12] = {};
	for(int j = 0; j< 5; j++){
		std::cout << "これはGDBのテストです:" ;
		std::cout << i[j] << std::endl;
		// std::cout << func(i[j]) << std::endl;
		sleep(1);
	}
	return 0;
}
