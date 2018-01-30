#include "tm4c123gh6pm.h"
#include "Queue.h"

#define Queue_Size  500																	// Queue Size



volatile unsigned long QueueSrc[Queue_Size];						// Declatration of Queue
unsigned long FRONT, REAR;															// Queue Pionters

//****************QueueInsert*****************
// This functions addes data in queue	and updated REAR Pointer
// inputs: unsigned long Data
// outputs: none

void QueueInsert(unsigned long Data)
{
	if((FRONT == 0 && REAR == Queue_Size - 1) || (FRONT == REAR + 1))		// If Queue is Full
	{
		GPIO_PORTF_DATA_R = 0x02;																					// Turn on Red LED
		Error_Handler();																									// Go to Error Handler
		return;
	}
	
	if(FRONT == 0)																											// If Queue is empty
	{
		FRONT = 1;																												// initilize the Front pointer to 1
		REAR = 1;																													// initilize the Rear pointer to 1
	}
	else if (REAR == Queue_Size - 1)																		// If rear pointer points last word in queue
		REAR = 1;																													// Update the pointer to 1st word
	else
		REAR = REAR + 1;																									// Increment the rear pointer
	
	QueueSrc[REAR] = Data;																							// Save the data in queue

}

//****************QueueRead*****************
// This functions reads data from queue	and updated FRONT Pointer
// inputs: none
// outputs: unsigned long Data

unsigned long QueueRead(void)
{
	unsigned long Data;
	if(FRONT == 0)																									// If Queue is empty
	{
		GPIO_PORTF_DATA_R = 0x08;																			// Turn on Green LED
		Error_Handler();																							// Go to Error Handler
		return 0;
	}
	
	Data = QueueSrc[FRONT];																					// Read the data from queue
	
	if(FRONT == REAR)																								// if Queue is empty
	{	
		FRONT = 0;																										// point the front pointer to NULL
		REAR = 0;																											// point the Rear pointer to NULL
	}
	else if(FRONT == Queue_Size - 1)																// if Front pointer points to last word in queue
	{	
		FRONT = 1;																										// Update Front pointer to 1st word of Queue
	}
	else
		FRONT = FRONT + 1;																						// Increment the Front Rointer
	
	return Data;																										// Return the data 
}

//****************QueuePeek*****************
// This functions reads data from queue no Pointer is updated
// inputs: none
// outputs: unsigned long Data

unsigned long QueuePeek(void)
{
	return QueueSrc[FRONT];																					// Return the Front Data in Queue
}

//****************QueueStat*****************
// This functions returns the status of Queue
// inputs: none
// outputs: unsigned long Stat

unsigned long QueueStat(void)
{
	if(FRONT == 0)																										// Check if Queue is empty
	{
		return QEmpty;																									// Return QEmpty
	}
	if((FRONT == 0 && REAR == Queue_Size - 1) || (FRONT == REAR + 1))	// Check if Queue is Full
	{
		return QFull;																										// Return QFull
	}
	else
		return QOkay;																										// Return QOkay
}

//****************Error_Handler*****************
// This functions keeps the controller in while(1) loop doing nothing
// This functions is used to detect errors
// inputs: none
// outputs: none

void Error_Handler(void)
{
	while(1)																													// While loop doing nothing
	{
		
	}
}
