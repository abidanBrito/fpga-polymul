#define PKE_N 256    // N of Rq = Zq[x]/<x^N + 1>
#define PKE_q 18434813901432784897   // modulus q

#define PKE_MESSAGEBYTES 32		// Size of message to be encrypted
#define PKE_NOISE_SEEDBYTES 32	// Length of noise_seed in bytes
#define PKE_MU 8				// Binomial distribution parameter is the number of bits required to compute one binomial sample.
#define PKE_UNIFORM_SEEDBYTES 32 // Length of seed of uniform polynomial in bytes

#define PKE_POLYERRORBYTES (PKE_MU * PKE_N / 8) // Number of bytes to compute one binomial-distributed polynomial
#define PKE_POLYUNIFORMBYTES (16 * PKE_N / 8) // Number of bytes required to generate one uniformly-distributed polynomial

