/*
 * modular_arithmetic.c


 *
 *  Created on: 08-Nov-2022
 *      Author: ssinharoy
 */

#include<stdint.h>
#include "modular_arithmetic.h"


void sepInt(uint64_t &rh, uint64_t &rl, uint64_t r) {
	// assumes r is at most 64-bit
	// result: 32 bit | 32 bit
	rh = (r >> 32);
	rl = (uint64_t) (r - (rh << 32));
}

void intMul(uint64_t &rh, uint64_t &rl, uint64_t a, uint64_t b) {
	// assumes a,b are at most 64-bit
	// result: 64 bit | 64 bit
	uint64_t ah,al,bh,bl;
	sepInt(ah,al,a);
	sepInt(bh,bl,b);

	uint64_t alxbl = al * bl;
	uint64_t alxbh = al * bh;
	uint64_t ahxbl = ah * bl;
	uint64_t ahxbh = ah * bh;

	uint64_t alxbl_h,alxbl_l;
	uint64_t alxbh_h,alxbh_l;
	uint64_t ahxbl_h,ahxbl_l;
	uint64_t ahxbh_h,ahxbh_l;

    sepInt(alxbl_h,alxbl_l,alxbl);
	sepInt(alxbh_h,alxbh_l,alxbh);
	sepInt(ahxbl_h,ahxbl_l,ahxbl);
	sepInt(ahxbh_h,ahxbh_l,ahxbh);

    uint64_t r_l,r_h;
	uint64_t r_1,r_2,r_3,r_4;

	r_1 = alxbl_l;
	r_2 = alxbl_h + alxbh_l + ahxbl_l;
	r_3 = ahxbh_l + alxbh_h + ahxbl_h + (r_2 >> 32);
	r_4 = ahxbh_h + (r_3 >> 32);

	r_l = r_1 + ((r_2 & 0xffffffff) << 32);
	r_h = (r_4 << 32) + (r_3 & 0xffffffff);

	rh = r_h;
	rl = r_l;
}

void intAdd(uint64_t &rh, uint64_t &rl, uint64_t a, uint64_t b) {
	// assumes a,b are at most 64-bit
	// result: 64 bit | 64 bit
	uint64_t ah,al,bh,bl;
	sepInt(ah,al,a);
	sepInt(bh,bl,b);

	uint64_t al_bl = al + bl;
	uint64_t ah_bh = ah + bh + (al_bl >> 32);

    uint64_t r_l,r_h;

	r_l = (al_bl & 0xffffffff) + ((ah_bh & 0xffffffff) << 32);
	r_h = (ah_bh >> 32);

	rh = r_h;
	rl = r_l;
}

void mulMod(uint64_t *r, uint64_t a, uint64_t b, uint64_t muh, uint64_t mul, uint64_t m, uint64_t ml) {
	// assumes m is 64-bit
	// assumes mu is 65-bit

	// d=a*b
	uint64_t dh, dl;
	intMul(dh, dl, a, b);

	// t = {dh*mu, dl*mu}
	uint64_t dhmul_h, dhmul_l, dlmul_h, dlmul_l, dhmuh, dlmuh;
	intMul(dhmul_h, dhmul_l, dh, mul);
	intMul(dlmul_h, dlmul_l, dl, mul);
	dhmuh = dh * muh;
	dlmuh = dl * muh;

	// t = t >> 128
	uint64_t th_2,th_1,th,tl;
	intAdd(th_1, tl, dlmul_h, dhmul_l);
	intAdd(th_2, tl, tl, dlmuh);
	th = th_1 + th_2;

	intAdd(th_1, tl, dhmul_h, dh);
	intAdd(th_2, tl, tl, th);
	th = th_1 + th_2;

	//printf("%llu %llu \n",th,tl); // DEBUG POINT

	// z = t*m
	uint64_t tlm_h, tlm_l, thm;
	intMul(tlm_h, tlm_l, tl, m);
	thm = th * m;
	tlm_h = tlm_h + thm;

	//printf("%llu %llu \n",tlm_h,tlm_l); // DEBUG POINT

	// final result = d - z
	uint64_t fr_h, fr_l;
	fr_h = (uint64_t) (dh - tlm_h);
	//uint64_t fr_l = (uint64_t) (dl - tlm_l);

	// final correction
	if(fr_h == 1) {
		fr_l = (uint64_t) (dl + ml - tlm_l);
	}
	else {
	    fr_l = (uint64_t) (dl - tlm_l);
	}

	if(fr_l >= m) {
		fr_l = (uint64_t) (fr_l - m);
	}

	*r = fr_l;
}

/*
int main() {
	uint64_t a,b,q,qm,muh,mul;
	uint64_t *r;

	uint64_t h,l;

    q = 18434813901432784897;
    qm= 11930172276766719;
    mul=11937892941120280;
	muh=1;

    a  = 6003040103881212130;
    b  = 7894411969189657731;
    // a*b= 47390471647605367358504098956105477030;
    // a*b %q: 3055981390027029119


	intMul(h,l,a,b);
	mulMod(r,a,b,muh,mul,q,qm);
	printf("Result: %llu \n",*r);

	return 0;
}
*/
