/*
 * instruction.h
 *
 *  Created on: 08-Dec-2021
 *      Author: ssinharoy
 */

#ifndef SRC_INSTRUCTION_H_
#define SRC_INSTRUCTION_H_

//void init_INS_TRNG(unsigned long long *INS);

void init_INS_TRNG(unsigned long long *INS, unsigned int NUM_WORDS, unsigned int DST_ADDRESS);

void init_INS_AES_Enc(unsigned long long *INS, unsigned int INP_ADDRESS, unsigned int OUT_ADDRESS);
void init_INS_AES_Dec(unsigned long long *INS, unsigned int INP_ADDRESS, unsigned int OUT_ADDRESS);

void init_INS_Poly_sub(unsigned long long *INS, unsigned int INP_ADDRESS1, unsigned int INP_ADDRESS2, unsigned int OUT_ADDRESS);

void init_INS_Poly_add(unsigned long long *INS, unsigned int INP_ADDRESS1, unsigned int INP_ADDRESS2, unsigned int OUT_ADDRESS);
void init_INS_Poly_mult(unsigned long long *INS, unsigned int INP_ADDRESS1, unsigned int INP_ADDRESS2, unsigned int OUT_ADDRESS);
void init_INS_Poly_mult_3poly(unsigned long long *INS, unsigned int INP_ADDRESS1, unsigned int INP_ADDRESS2, unsigned int OUT_ADDRESS);



#endif /* SRC_INSTRUCTION_H_ */
