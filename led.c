#include <stdio.h>


int main(void)
{
    volatile int* led = (int*) 0xFF200010; // rLED addr 
    volatile int* switchptr = (int*) 0xFF200000; // SW addr 
    volatile int* hex3 = (int*) 0xFF200020; // 
    int switch_value; 

    while(1){
        switch_value = *(switchptr); 
		*hex3 = switch_value;
	//printf("%d\n", switch_value); 
        *led = switch_value;    
    }
}
