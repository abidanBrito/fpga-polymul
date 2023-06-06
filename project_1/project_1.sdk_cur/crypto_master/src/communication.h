/*
 * communication.h
 *
 *  Created on: 08-Dec-2021
 *      Author: ssinharoy
 */

#ifndef SRC_COMMUNICATION_H_
#define SRC_COMMUNICATION_H_


void send64(uint64_t *p, uint32_t base_address, uint32_t num_words, uint32_t INS_flag);
void receive64(uint64_t *p, uint32_t base_address, uint32_t num_words);
void exeIns();

uint32_t delay(uint32_t d);


#endif /* SRC_COMMUNICATION_H_ */
