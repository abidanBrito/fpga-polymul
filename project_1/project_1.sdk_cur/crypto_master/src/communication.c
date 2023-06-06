/*
 * communication.h
 *
 *  Created on: 06-Oct-2021
 *      Author: ssinharoy
 */
#ifndef SRC_COMMUNICATION_C_
#define SRC_COMMUNICATION_C_
#include "xparameters.h"
#include "xtime_l.h"
#include <stdio.h>
#include<stdint.h>
#include "communication.h"

extern volatile uint32_t * axi_address_base;

void send64(uint64_t *p, uint32_t base_address, uint32_t num_words, uint32_t INS_flag)
{
	XTime tStart,tEnd;

	uint32_t i, j;

	uint32_t address_ext = base_address; 	// control[9:0];
	uint32_t wea_ext = 0; 					// control[10];
	uint32_t control_low = 0;
	uint32_t dina_low=0, dina_high=0;
	uint64_t temp;

    XTime_GetTime(&tStart);

	//printf("Send:num_words = %d\n", num_words);
	for(i=0; i<num_words; i++)
	{
		temp = p[i];
		dina_low = temp & 0xFFFFFFFF;
		temp = temp >> 32;
		dina_high = temp & 0xFFFFFFFF;
		wea_ext = 1;
		address_ext = base_address + i;
		control_low = (INS_flag<<11) + (wea_ext<<10) + address_ext;
		//printf("Send[%d] dina_high = %x dina_low = %x\n", i, dina_high, dina_low);
		axi_address_base[0] = control_low;
		axi_address_base[2] = dina_low; axi_address_base[3] = dina_high;
		for(j=0; j<1000; j++);

		wea_ext = 0;
		control_low = (wea_ext<<10) + address_ext;

		axi_address_base[0] = control_low;
		for(j=0; j<1000; j++);
	}
	XTime_GetTime(&tEnd);
	printf("Sending data to FPGA took %llu clock cycles \n",2*(tEnd-tStart)/1000);

}

void receive64(uint64_t *p, uint32_t base_address, uint32_t num_words)
{
	XTime tStart,tEnd;

	int i, j;

	uint32_t address_ext = base_address; 	// control[9:0];
	uint32_t wea_ext = 0; 					// control[10];
	uint32_t control_low = 0;
	uint32_t dina_low=0, dina_high=0;

	//printf("Receive:num_words = %d\n", num_words);

    XTime_GetTime(&tStart);

	for(i=0; i<num_words; i++)
	{
		address_ext = base_address + i;
		control_low = (wea_ext<<10) + address_ext;

		axi_address_base[0] = control_low;
		dina_low = axi_address_base[4];
		dina_high = axi_address_base[5];

		for(j=0; j<1000; j++);

		p[i] = dina_high & 0xFFFFFFFF;
		p[i] = p[i] << 32;
		p[i] = p[i] + dina_low;
	}
	XTime_GetTime(&tEnd);
	printf("Receiving data from FPGA took %llu clock cycles \n",2*(tEnd-tStart)/1000);

}

void exeIns()
{
	XTime tStart,tEnd;

	// control_low_word (axi_address_base[0]),
	// control_high_word (axi_address_base[1]),
	// dina_ext_low_word (axi_address_base[2]),
	// dina_ext_high_word (axi_address_base[3]),
	// output [31:0] dout_ext_low_word, dout_ext_high_word;
	// output [31:0] status;

	// address_ext = control_low[9:0];
	// wea_ext = control_low[10];
	// rst = control_high[0];
	// start = control_high[1];


	uint32_t control_low = 0, control_high = 0;
	int i;
	uint32_t trng_error;
	uint32_t cycle_count;

	// Reset Processor
	control_low = 0; control_high=1;
	axi_address_base[0] = control_low;
	axi_address_base[1] = control_high;


	for(i=0; i<1000; i++);


	//printf("Status = %x\n", axi_address_base[6] & 0x1);

	trng_error = (uint32_t) axi_address_base[6];
	trng_error = (trng_error & 2)>>1;
	//printf("Trng error: %u\n", trng_error);


	control_low = 0; control_high=2;
	axi_address_base[0] = control_low;
	axi_address_base[1] = control_high;

	//for(i=0; i<10000; i++);

	while((axi_address_base[6] & 0x1) == 0){
		//printf("Computation done = %x\n", axi_address_base[6]&0x1);
		trng_error = (uint32_t) axi_address_base[6];
		trng_error = (trng_error & 2)>>1;
		//printf("Trng error: %u\n", trng_error);
	}

	//printf("Status after executing instructions = %x\n", axi_address_base[6] & 0x1);
	cycle_count = (uint32_t) axi_address_base[6];
	cycle_count = (cycle_count>>2);
	printf("FPGA cycle count: %u is equivalent to %u CPU cycle count\n", cycle_count, cycle_count*5);
	trng_error = (uint32_t) axi_address_base[6];
	trng_error = (trng_error & 2)>>1;
	//printf("Trng error: %u\n", trng_error);

	// Reset Processor
	control_low = 0; control_high=1;
	axi_address_base[0] = control_low;
	axi_address_base[1] = control_high;

	for(i=0; i<1000; i++);


	//printf("Final Status = %x\n", axi_address_base[6] & 0x1);
	trng_error = (uint32_t) axi_address_base[6];
	trng_error = (trng_error & 2)>>1;
	//printf("Trng error: %u\n", trng_error);

}

uint32_t delay(uint32_t d){
	uint32_t i, j;

	for(i=0; i<d; i++)
		j += i;

	return j;
}

#endif /* SRC_COMMUNICATION_C_ */
