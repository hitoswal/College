// Piano.h
// This software configures the off-board piano keys
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/26/2015 
// Last Modified: 10/29/2015
// Lab number: 4

// Hardware connections

#define Key_0										(*((volatile unsigned long *)0x40007004))			//Port D PIN PD0
#define Key_1										(*((volatile unsigned long *)0x40007008))			//Port D PIN PD1
#define Key_2										(*((volatile unsigned long *)0x40007010))			//Port D PIN PD2
#define Key_3										(*((volatile unsigned long *)0x40007020))			//Port D PIN PD3

// **************Piano_Init*********************
// Initialize piano key inputs, called once 
// Input: none 
// Output: none
void Piano_Init(void);

// **************Piano_In*********************
// Input from piano key inputs 
// Input: none 
// Output: 0 to 8 depending on keys
// 0x01 is just Key_0, 0x02 is just Key_1, 0x04 is just Key_2, 0x08 is just Key_3
unsigned long Piano_In(void);



