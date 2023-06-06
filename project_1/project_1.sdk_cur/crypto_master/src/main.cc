#include<stdio.h>
#include<getopt.h>
#include<limits.h>
#include<stdint.h>
#include<stdlib.h>

#include "platform.h"
#include "xil_printf.h"
#include "xil_cache.h"

volatile uint32_t * axi_address_base;

// Block-related headers
#include "pke/test_polymul.h"



int main(){
	uint32_t i, j, r;
	uint64_t INS[64];
	uint64_t fpga_memory_data[1024]; // This is a memory buffer in SW. This buffer is used to read contents from the BRAM-memory of FPGA.


	init_platform();
	//axi_address_base   = (uint32_t *) 0x00A0000000; 	// For zcu102 board
	axi_address_base   = (uint32_t *) 0x40000000;		// For PYNQ-z2 board

	int TEST_TYPE = 0; // 0: TRNG, 1:AES, 2:PKE, 3:End

	printf("******************************************************************\n");
	printf("*                          Starting SDK                          *\n");
	printf("******************************************************************\n");


	while(TEST_TYPE !=3){
		if(TEST_TYPE==0) 		test_polymul();
		else break;

		printf("Type of test [0: PolyMul, 3:End] : ");
		scanf("%d", &TEST_TYPE);
	}


	Xil_DCacheFlush();
	Xil_DCacheDisable();

	printf("Finish\n");

	cleanup_platform();
	return 0;

}	
