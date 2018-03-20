#include <iostream>

int main(int argc, char **argv) {
	int data[1000000];
	for(int i = 0; i < 1000000; ++i) data[i] = i;

	std::cout << "================" << std::endl;

	int sum = 0;
	for(int run = 0; run < 1000; ++ run) {
		sum = 0;
		for(int i = 0; i < 10000; ++i) sum += data[i * (argc < 2 || argv[1][0] == 's' ? 1 : 100)];
	}

	std::cout << "================" << std::endl;

	std::cout << sum << std::endl;
}