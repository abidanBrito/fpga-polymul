/*
 * modular_arithmetic.h
 *
 *  Created on: 08-Nov-2022
 *      Author: ssinharoy
 */


void sepInt(uint64_t &rh, uint64_t &rl, uint64_t r);

void intMul(uint64_t &rh, uint64_t &rl, uint64_t a, uint64_t b);

void intAdd(uint64_t &rh, uint64_t &rl, uint64_t a, uint64_t b);

void mulMod(uint64_t *r, uint64_t a, uint64_t b, uint64_t muh, uint64_t mul, uint64_t m, uint64_t ml);
