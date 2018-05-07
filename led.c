#include <stdio.h>
#include <string.h>

#define HEX5_HEX0BUS 		((volatile) (int*) 0xFF200010)
#define AVALON_INTFACE_ADDR ((volatile) (int*) 0xFF200028)

int main(void){
   //	volatile int* hex5_hex0_bus = (int*) 0xFF200010; 
	volatile int* reg32_intface = (int*) 0xFF200028;

	char buffer[25];
	int number;

	while(1){
		printf("Enter an integer or 'exit': ");
		fgets(buffer, 25, stdin); // Get input from stdin
		sscanf(buffer, "%d\n", &number);
		if (!strcmp(buffer, "exit\n"))
			break;

		printf("You entered %x\n", number);
		fflush(stdin);
		*reg32_intface = number; // Try the hex bus
	}
	return 0;
}
