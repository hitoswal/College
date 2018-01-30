#define QFull     0
#define QEmpty    1
#define QOkay			3

//****************QueueInsert*****************
// This functions addes data in queue	and updated REAR Pointer
// inputs: unsigned long Data
// outputs: none

unsigned long QueueRead(void);

//****************QueueRead*****************
// This functions reads data from queue	and updated FRONT Pointer
// inputs: none
// outputs: unsigned long Data

void QueueInsert(unsigned long);

//****************QueuePeek*****************
// This functions reads data from queue no Pointer is updated
// inputs: none
// outputs: unsigned long Data

unsigned long QueuePeek(void);

//****************Error_Handler*****************
// This functions keeps the controller in while(1) loop doing nothing
// This functions is used to detect errors
// inputs: none
// outputs: none

void Error_Handler(void);

//****************QueueStat*****************
// This functions returns the status of Queue
// inputs: none
// outputs: unsigned long Stat

unsigned long QueueStat(void);
