#include<stdio.h>
#include "instruction.h"
 /*
 *  This function lists all the instruction opcodes that will be loaded into the program memory.
 *  The program controller in the FPGA runs the instructions one-by-one starting from ins_group[0],
 *  then ins_group[1], then ins_group[2], etc.
 *  In the current implementation, the program memory in the FPGA has 64 words only.
 *  So, a maximum of 64 instructions can be executed.
 *  Instruction code 0x1f is used to indicate the end of a program. It must be present.
 */

void init_INS_TRNG(unsigned long long *INS, unsigned int NUM_WORDS, unsigned int DST_ADDRESS)
{
	/*
	 It asks the TRNG wrapper to generate 512 random words (hence 512*64 bits).
	 program _word = (INS_we<<35) + (OP3<<25) + (OP2<<15) + (OP1<<5) + INS_CODE.
	 In the example:
	 	 INS_CODE=18,
	 	 OP1=number of random words;
	 	 OP2=0 (not used);
	 	 OP3=write start address;
	 	 INS_we = 1.
	 	 E.g., with OP1=512 and OP3=0, the program-word value = 0x800004012.
	 	 You can change OP1 (number of rng words) and OP3 (destination) as per your need.
	 */
	int i;

	unsigned long long program_word =  ((unsigned long long) 1<<35) + (DST_ADDRESS<<25) + (NUM_WORDS<<5)+ 18;

	//printf("program_word = %llx\n", program_word);

	unsigned long long ins_group[64] =
	{
			0x0000000000,
			0x0800004012,
			0x0800000000,
			0x0000000000,
			0x000000001f	// End of computation
	};

	ins_group[1] = program_word;
	for(i=0; i<64; i++)
		INS[i] = ins_group[i];
}

void init_INS_AES_Enc(unsigned long long *INS, unsigned int INP_ADDRESS, unsigned int OUT_ADDRESS)
{
	/*
	 It asks the AES core to take input (2 words plaintext or ciphertext) at addresses INP_ADDRESS, INP_ADDRESS+1 and
	     keys (22 words) at addresses from INP_ADDRESS+2 to INP_ADDRESS+23, perform encryption and
	     write the result (2 words plaintext or ciphertext) to addresses OUT_ADDRESS, OUT_ADDRESS+1.
	 program _word = (INS_we<<35) + (OP3<<25) + (OP2<<15) + (OP1<<5) + INS_CODE.
	 In the example:
	 	 INS_CODE=19,
	 	 OP1=read start address for input (plaintext + keys);
	 	 OP2=0 (not used);
	 	 OP3=write start address for output;
	 	 INS_we = 1.
	 	 E.g., with OP1=0 and OP3=24, the program-word value = 0x830000013.
	 	 You can change OP1 (start address for plaintext + keys) and OP3 (destination) as per your need.
	*/
	int i;

	unsigned long long program_word =  ((unsigned long long) 1<<35) + (OUT_ADDRESS<<25) + (INP_ADDRESS<<5) + 19;

	unsigned long long ins_group[64] =
	{
			0x0000000000,
			0x0830000013,	// This instruction is overwritten by the input
			0x0800000000,
			0x0000000000,
			0x000000001f    // End of computation
	};

	ins_group[1] = program_word;
	for(i=0; i<64; i++)
		INS[i] = ins_group[i];
}

void init_INS_AES_Dec(unsigned long long *INS, unsigned int INP_ADDRESS, unsigned int OUT_ADDRESS)
{
	/*
	 It asks the AES core to take input (2 words plaintext or ciphertext) at addresses INP_ADDRESS, INP_ADDRESS+1 and
	     keys (22 words) at addresses from INP_ADDRESS+2 to INP_ADDRESS+23, perform decryption and
	     write the result (2 words plaintext or ciphertext) to addresses OUT_ADDRESS, OUT_ADDRESS+1.
	 program _word = (INS_we<<35) + (OP3<<25) + (OP2<<15) + (OP1<<5) + INS_CODE.
	 In the example:
	 	 INS_CODE=20,
	 	 OP1=read start address for input (plaintext + keys);
	 	 OP2=0 (not used);
	 	 OP3=write start address for output;
	 	 INS_we = 1.
	 	 E.g., with OP1=0 and OP3=24, the program-word value = 0x830000014.
	 	 You can change OP1 (start address for plaintext + keys) and OP3 (destination) as per your need.
	*/
	int i;

	unsigned long long program_word =  ((unsigned long long) 1<<35) + (OUT_ADDRESS<<25) + (INP_ADDRESS<<5) + 20;

	unsigned long long ins_group[64] =
	{
			0x0000000000,
			0x0830000014,	// This instruction is overwritten by the input
			0x0800000000,
			0x0000000000,
			0x000000001f    // End of computation
	};

	ins_group[1] = program_word;
	for(i=0; i<64; i++)
		INS[i] = ins_group[i];
}


void init_INS_Poly_add(unsigned long long *INS, unsigned int INP_ADDRESS1, unsigned int INP_ADDRESS2, unsigned int OUT_ADDRESS)
{
	int i;

		unsigned long long program_word =  ((unsigned long long) 1<<35) + (OUT_ADDRESS<<25) + (INP_ADDRESS2<<15)+(INP_ADDRESS1<<5) + 22;

		unsigned long long ins_group[64] =
		{
				0x0000000000,
				0x0830000014,	// This instruction is overwritten by the input
				0x0800000000,
				0x0000000000,
				0x000000001f    // End of computation
		};

		ins_group[1] = program_word;
		for(i=0; i<64; i++)
			INS[i] = ins_group[i];
}
void init_INS_Poly_sub(unsigned long long *INS, unsigned int INP_ADDRESS1, unsigned int INP_ADDRESS2, unsigned int OUT_ADDRESS)
{
	int i;

		unsigned long long program_word =  ((unsigned long long) 1<<35) + (OUT_ADDRESS<<25) + (INP_ADDRESS2<<15)+(INP_ADDRESS1<<5) + 23;

		unsigned long long ins_group[64] =
		{
				0x0000000000,
				0x0830000014,	// This instruction is overwritten by the input
				0x0800000000,
				0x0000000000,
				0x000000001f    // End of computation
		};

		ins_group[1] = program_word;
		for(i=0; i<64; i++)
			INS[i] = ins_group[i];
}
void init_INS_Poly_mult(unsigned long long *INS, unsigned int INP_ADDRESS1, unsigned int INP_ADDRESS2, unsigned int OUT_ADDRESS)
{
	int i;
		printf("OUT_ADDRESS=%d\n", OUT_ADDRESS);


		unsigned long long program_word_1 =  ((unsigned long long) 1<<35) + ((unsigned long long) INP_ADDRESS1<<25) + (INP_ADDRESS1<<15)+(INP_ADDRESS1<<5) + 24;
		unsigned long long program_word_2 =  ((unsigned long long) 1<<35) + ((unsigned long long) INP_ADDRESS2<<25) + (INP_ADDRESS2<<15)+(INP_ADDRESS2<<5) + 24;
		unsigned long long program_word_3 =  ((unsigned long long) 1<<35) + ((unsigned long long) OUT_ADDRESS<<25) + (INP_ADDRESS2<<15)+(INP_ADDRESS1<<5) + 26;
		unsigned long long program_word_4 =  ((unsigned long long) 1<<35) + ((unsigned long long) OUT_ADDRESS<<25) + (OUT_ADDRESS<<15)+(OUT_ADDRESS<<5) + 25;

		//printf("Program word = %llu\n", program_word);
		unsigned long long ins_group[64] =
		{
				0x0000000000,
				0x0000000000,	// This instruction is overwritten by the input (original 0x0830000014)
				0x0000000000,	// This instruction is overwritten by the input
				0x0000000000,	// This instruction is overwritten by the input
				0x0000000000,	// This instruction is overwritten by the input
				0x0800000000,
				0x0000000000,
				0x000000001f    // End of computation
		};

		ins_group[1] = program_word_1;
		//ins_group[2] = program_word_2;
		//ins_group[3] = program_word_3;
		//ins_group[4] = program_word_4;
		for(i=0; i<64; i++)
			INS[i] = ins_group[i];
}
void init_INS_Poly_mult_3poly(unsigned long long *INS, unsigned int INP_ADDRESS1, unsigned int INP_ADDRESS2, unsigned int OUT_ADDRESS)
{
	int i;

		unsigned long long program_word1 =  ((unsigned long long) 1<<35) + (OUT_ADDRESS<<25) + (INP_ADDRESS2<<15)+(INP_ADDRESS1<<5) + 24;
		unsigned long long program_word2 =  ((unsigned long long) 1<<35) + ((OUT_ADDRESS+32)<<25) + ((INP_ADDRESS2+8)<<15)+((INP_ADDRESS1+16)<<5) + 24;
		unsigned long long program_word3 =  ((unsigned long long) 1<<35) + ((OUT_ADDRESS+64)<<25) + ((INP_ADDRESS2+16)<<15)+((INP_ADDRESS1+32)<<5) + 24;

		unsigned long long ins_group[64] =
		{
				0x0000000000,
				0x0830000014,	// This instruction is overwritten by the input
				0x0800000000,
				0x0000000000,
				0x0830000014,	// This instruction is overwritten by the input
				0x0800000000,
				0x0000000000,
				0x0830000014,	// This instruction is overwritten by the input
				0x0800000000,
				0x0000000000,
				0x000000001f    // End of computation
		};

		ins_group[1] = program_word1;
		ins_group[4] = program_word2;
		ins_group[7] = program_word3;
		for(i=0; i<64; i++)
			INS[i] = ins_group[i];
}


