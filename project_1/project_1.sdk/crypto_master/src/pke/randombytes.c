#include<stdint.h>
#include<stdlib.h>
#include "randombytes.h"
#include "../instruction.h"
#include "../communication.h"


void randombytes(uint8_t *seed, int num_bytes)
{
	int i;
	for(i=0; i<num_bytes; i++)
		seed[i] = rand() & 255;
}

/*
// randombytes using TRNG
void randombytes(uint8_t *seed, int num_bytes)
{
	int i;

	if(num_bytes%8 != 0) {
		printf("Error: Number of TRNG bytes must be a multiple of 8.\n");
		exit(-1);
	}
	uint64_t INS[64];
	uint64_t buf[16];
	init_INS_TRNG(INS, 4, 0);
	send64(INS, 0, 64, 1); // send INStructions to FPGA using send64() function.
	printf("... Generating True random words\n");
	exeIns();
	delay(1000);
	receive64(buf, 0, num_bytes/8);	// Buffer contains TRNG words.
	delay(1000);
	printf("... done\n");
	//printf("rng_buf %llx\n", buf[0]);

	// Now copy TRNG_word-bytes into seed.
	uint8_t *pt = (uint8_t *) buf;
	for(i=0; i<num_bytes; i++)
		seed[i] = pt[i];

	// Left as TO DO:
	// Make sure that this seed is sufficiently long depending on the min-entropy
	// so that it can be compressed into a high-quality seed.
}
*/
