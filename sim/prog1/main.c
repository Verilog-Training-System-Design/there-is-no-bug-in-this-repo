#include <stdint.h>

#define MIP_MEIP (1 << 11) // External interrupt pending
#define MIP_MTIP (1 << 7)  // Timer interrupt pending
#define MIP 0x344

volatile unsigned int *WDT_addr = (int *) 0x10010000;
volatile unsigned int *dma_addr_boot = (int *) 0x10020000;

void timer_interrupt_handler(void) {
  asm("csrsi mstatus, 0x0"); // MIE of mstatus
  WDT_addr[0x40] = 0; // WDT_en
  asm("j _start");
}

void external_interrupt_handler(void) {

}

void trap_handler(void) {
    uint32_t mip;
    asm volatile("csrr %0, %1" : "=r"(mip) : "i"(MIP));
	
    if ((mip & MIP_MTIP) >> 7) {
        timer_interrupt_handler();
    }

    if ((mip & MIP_MEIP) >> 11) {
        external_interrupt_handler();
    }
}

// void swap(int16_t* a, int16_t* b){
// 	int16_t temp = *a;
// 	*a = *b;
// 	*b = temp;
// }

// extern unsigned int array_size;
// extern int array_addr;
// extern int _test_start;

// void bubble_sort(int array[], int n, int test[]){
// 	short tmp, data1, data2;
// 	int key;
// 	for(int i=n-1 ; i>0 ; i--){
// 		for(int j=0 ; j <= i-1 ;j++){
// 			key = array[j];
// 			data1	=	(short)key;
// 			data2	=	(short)(key >> 16);
// 			if(data1 > data2){
// 				tmp = data1;
// 				data1 = data2;
// 				data2 = tmp;
// 				// swap(&array[j], &array[j+1]);
// 			}
// 			key	=	(data2<<16) | data1;		
// 			array[j] = key;		
// 		}
// 	}
// 	// unsigned int temp;
// 	for(int i=0 ; i<n ; i++){
//         // temp = array[j];
// 		// temp = temp << 16;
// 		// temp = temp + (unsigned int)(array[j+1]);
// 		// test[i] = temp;
// 		// j = j+2;
// 		test[i] = array[i];
//     }
// }

// int main(){
// 	bubble_sort(&array_addr, array_size/2, &_test_start);
// 	return 0;
// }





// extern unsigned int array_size;
// extern int array_addr;
// extern short _test_start;
// int main(void)
// {

//   int i, j, key;
//   short data1 ,data2;

//   for (i = 1; i < array_size; i++)
//   {
// 	// if(i % 2 == 1)
// 	// 	key = (&array_addr)[i] >> 16;
// 	// else 
// 	key = (&array_addr)[0];
// 	data1	=	key;
// 	data2	=	key >> 16;

//     j = i - 1;

//     while (j >= 0 && (&array_addr)[j] > key)
//     {
//       (&array_addr)[j + 1] = (&array_addr)[j];
//       j = j - 1;
//     }

//     (&array_addr)[j + 1] = key;
//   }

//   for (i = 0; i < array_size; i++)
//   {
//     (&_test_start)[i] = (&array_addr)[i];
//   }

//   return 0;
// }


//11/30 midnight

// extern unsigned int array_size;
// extern int array_addr;
// extern int _test_start;

// void bubble_sort(int array[], int n, int test[]){
// 	int tmp, data1, data2;
// 	int key;
// 	// for(int i=n-1 ; i>0 ; i--){
// 	for(int j=0 ; j <= n-1 ;j++){
// 		key = array[j];
// 		data1	=	(key & 0x0000ffff);
// 		data2	=	((key >> 16) & 0x0000ffff);
// 		if(data1 > data2){
// 			tmp = data1;
// 			data1 = data2;
// 			data2 = tmp;
// 			// swap(&array[j], &array[j+1]);
// 		}
// 		key	=	(((int)data2)<<16) | (((int)data1) & 0x0000ffff);	
// 		array[j] = key;		
// 	}
// 	// }
// 	// unsigned int temp;
// 	for(int i=0 ; i<n ; i+=2){
//         // temp = array[j];
// 		// temp = temp << 16;
// 		// temp = temp + (unsigned int)(array[j+1]);
// 		// test[i] = temp;
// 		// j = j+2;
// 		test[i] = array[0];
//     }
// }

// int main(){
// 	bubble_sort(&array_addr, array_size, &_test_start);
// 	return 0;
// }



extern unsigned int array_size;
extern int array_addr;
extern int _test_start;

void bubb_sort(int array[], int n, int test[]){
	int tmp, data1, data2, min;
	int num[128];
	int key;
	// for(int i=n-1 ; i>0 ; i--){
	int i = 0;
	for(int j=0 ; j < n ; j+=2){
		key = array[i];
		data1	=	(key & 0xffff0000);
		data2	=	((key << 16));
		num[j] = data1;
		num[j+1] = data2;
		i++;
	}
	for(int i=n-1 ; i>0 ; i--){
		for(int j=0 ; j <= i-1 ;j++){
			if(num[j] > num[j+1]){
				tmp = num[j];
				num[j] = num[j+1];
				num[j+1] = tmp;
				// swap(&array[j], &array[j+1]);
			}	
		}
	}
	// }
	// unsigned int temp;
	
        // temp = array[j];
		// temp = temp << 16;
		// temp = temp + (unsigned int)(array[j+1]);
		// test[i] = temp;
		// j = j+2;
	int j=0;
	for(int i=0 ; i<n/2 ;i++){
		key	=	((((int)num[j] >> 16)) & 0x0000ffff) | (((int)num[j+1]));	
		test[i] = key;
		j = j + 2;
	}
}

int main(){
	bubb_sort(&array_addr, array_size, &_test_start);
	return 0;
}