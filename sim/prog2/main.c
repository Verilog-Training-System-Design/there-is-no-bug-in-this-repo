// #include <stdint.h>

// #define MIP_MEIP (1 << 11) // External interrupt pending
// #define MIP_MTIP (1 << 7)  // Timer interrupt pending
// #define MIP 0x344

// // extern unsigned int _binary_image_bmp_start
// // extern unsigned int _binary_image_bmp_end
// // extern unsigned int _binary_image_bmp_size

// volatile unsigned int *WDT_addr = (int *) 0x10010000;
// volatile unsigned int *dma_addr_boot = (int *) 0x10020000;

// void timer_interrupt_handler(void) {
//   asm("csrsi mstatus, 0x0"); // MIE of mstatus
//   WDT_addr[0x40] = 0; // WDT_en
//   asm("j _start");
// }

// void external_interrupt_handler(void) {

// } 

// void trap_handler(void) {
//     uint32_t mip;
//     asm volatile("csrr %0, %1" : "=r"(mip) : "i"(MIP));
	
//     if ((mip & MIP_MTIP) >> 7) {
//         timer_interrupt_handler();
//     }

//     if ((mip & MIP_MEIP) >> 11) {
//         external_interrupt_handler();
//     }
// }

// // float Grayscale(int8_t B, int8_t G, int8_t R){
// //     float Gray_result;


    
// //     Gray_result = 0.11* B + 0.59* G +0.3* R;
// //     return Gray_result;
// // }
// // int main() {
// //     int data_get;
// //     int8_t B;
// //     int8_t G;
// //     int8_t R;

// //     for(data_get = 54; data_get < &; data_get += 3){
// //         B   = (&_binary_image_bmp_start)[data_get];
// //         G   = (&_binary_image_bmp_start)[data_get + 1];
// //         R   = (&_binary_image_bmp_start)[data_get + 2];
// //         Grayscale(B, G, R);
// //     }

// //     //result address
// //     extern float _test_start;
// //     for(){
// //     *(&_test_start)[i]  =   Grayscale(B, G, R);
// //     }
// //     return 0;
// // }

// int gray(int red, int green, int blue) {          //r
//     unsigned int tmp, result = 0;
//     tmp = red << 18;
//     result += tmp;
//     tmp = red << 15;
//     result += tmp;
//     tmp = red << 14;
//     result += tmp;
//     tmp = red << 11;
//     result += tmp;
//     tmp = red << 10;
//     result += tmp;
//     tmp = red << 7;
//     result += tmp;
//     tmp = red << 6;
//     result += tmp;
//     tmp = red << 3;
//     result += tmp;
//     tmp = red << 2;
//     result += tmp;
//     result += red;

//     tmp = green << 19;
//     result += tmp;
//     tmp = green << 16;
//     result += tmp;
//     tmp = green << 14;
//     result += tmp;
//     tmp = green << 13;
//     result += tmp;
//     tmp = green << 12;
//     result += tmp;
//     tmp = green << 7;
//     result += tmp;
//     tmp = green << 5;
//     result += tmp;
//     tmp = green << 2;
//     result += tmp;

//     tmp = blue << 16;
//     result += tmp;
//     tmp = blue << 15;
//     result += tmp;
//     tmp = blue << 14;
//     result += tmp;
//     tmp = blue << 9;
//     result += tmp;
//     tmp = blue << 7;
//     result += tmp;
//     tmp = blue << 4;
//     result += tmp;

//     result = result >> 20;
//     return result;
// }

// int main(void)
// {
//   extern char _test_start;
//   extern unsigned int _binary_image_bmp_start;
//   extern unsigned int _binary_image_bmp_end;
//   extern unsigned int _binary_image_bmp_size;

//   int i;
//   int j=0;
//   for (int i = 0; i < 54; i+=4){
//     (&_test_start)[i] = (&_binary_image_bmp_start)[j];
//     (&_test_start)[i+1] = (&_binary_image_bmp_start)[j] >> 8;
//     (&_test_start)[i+2] = (&_binary_image_bmp_start)[j] >> 16;
//     (&_test_start)[i+3] = (&_binary_image_bmp_start)[j] >> 24;
//     j = j + 1;
//   }
//   i=13;
//   int r = 0, b = 0, g = 0;
//   int ans = 0;
//   for (j = 54; j < _binary_image_bmp_size; j = j + 12)
//   {
//         int temp1 = (&_binary_image_bmp_start)[13];
//         int temp2 = (&_binary_image_bmp_start)[14];
//         int temp3 = (&_binary_image_bmp_start)[15];
//         int temp4 = (&_binary_image_bmp_start)[16];
//         r = (temp1 >> 16) & 0xff;
//         g = (temp1 >> 24) & 0xff;
//         b = temp2 & 0xff;
//         ans = gray(r, g, b);
//         (&_test_start)[j] = r;
//         (&_test_start)[j+1] = g;
//         (&_test_start)[j+2] = b;

//         r = (temp2 >> 8) & 0xff;
//         g = (temp2 >> 16) & 0xff;
//         b = (temp2 >> 24) & 0xff;
//         ans = gray(r, g, b);
//         (&_test_start)[j+3] = ans;
//         (&_test_start)[j+4] = ans;
//         (&_test_start)[j+5] = ans;

//         r = temp3 & 0xff;
//         g = (temp3 >> 8) & 0xff;
//         b = (temp3 >> 16) & 0xff;
//         ans = gray(r, g, b);
//         (&_test_start)[j+6] = ans;
//         (&_test_start)[j+7] = ans;
//         (&_test_start)[j+8] = ans;

//         r = (temp3 >> 24) & 0xff;
//         g = temp4 & 0xff;
//         b = (temp4 >> 8) & 0xff;
//         ans = gray(r, g, b);
//         (&_test_start)[j+9] = ans;
//         (&_test_start)[j+10] = ans;
//         (&_test_start)[j+11] = ans;
//         i+=3;
//   }
//   return 0;
// }


#include <stdint.h>

#define MIP_MEIP (1 << 11) // External interrupt pending
#define MIP_MTIP (1 << 7)  // Timer interrupt pending
#define MIP 0x344

volatile unsigned int *WDT_addr = (int *) 0x10010000;
volatile unsigned int *dma_addr_boot = (int *) 0x10020000;

//extern uint8_t _binary_image_bmp_start[];
//extern uint8_t _binary_image_bmp_end[];
//extern uint32_t _binary_image_bmp_size;
//extern uint8_t _test_start[];

void timer_interrupt_handler(void) {
  asm("csrsi mstatus, 0x0"); // MIE of mstatus
  WDT_addr[0x40] = 0; // WDT_en
  asm("j _start");
}

void external_interrupt_handler(void) {
 volatile unsigned int *dma_addr_boot = (int *) 0x10020000;
 asm("csrsi mstatus, 0x0"); // MIE of mstatus
 dma_addr_boot[0x40] = 0; // disable DMA
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
extern char _test_start;
extern unsigned int _binary_image_bmp_start;
extern unsigned int _binary_image_bmp_end;
extern unsigned int _binary_image_bmp_size;
int main(void)
{
  //extern unsigned int _test_start;
    unsigned  int *bmp = &_binary_image_bmp_start;
    char *test = &_test_start;

    int i = 0;
    int j = 0;
// test[0] = bmp[0] >> 0;
// test[1] = bmp[0] >> 8;

    for (i = 0; i < 53; i=i+4){
        test[i] = bmp[j];
        test[i+1] = bmp[j] >> 8;
        test[i+2] = bmp[j] >> 16;
        test[i+3] = bmp[j] >> 24;
        // (&_test_start)[i] = (&_binary_image_bmp_start)[j];
        // (&_test_start)[i + 1] = (&_binary_image_bmp_start)[j] >> 8;
        // (&_test_start)[i + 2] = (&_binary_image_bmp_start)[j] >> 16;
        // (&_test_start)[i + 3] = (&_binary_image_bmp_start)[j] >> 24;
        j= j+1;
    }
    j = 13;
    i = 54;
  int a = 0, b = 0, c = 0;
  int result = 0, tmp = 0;
  for (i = 54; i < &_binary_image_bmp_size ; i = i + 12)
  {

    result = 0, tmp = 0;
    c = (bmp[j]>> 16 )&0xff;
    b = (bmp[j]>> 24)&0xff;
    a = (bmp[j+1])&0xff;
    tmp = a << 18;
    result += tmp;
    tmp = a << 15;
    result += tmp;
    tmp = a << 14;
    result += tmp;
    tmp = a << 11;
    result += tmp;
    tmp = a << 10;
    result += tmp;
    tmp = a << 7;
    result += tmp;
    tmp = a << 6;
    result += tmp;
    tmp = a << 3;
    result += tmp;
    tmp = a << 2;
    result += tmp;
    result += a;

    tmp = b << 19;
    result += tmp;
    tmp = b << 16;
    result += tmp;
    tmp = b << 14;
    result += tmp;
    tmp = b << 13;
    result += tmp;
    tmp = b << 12;
    result += tmp;
    tmp = b << 7;
    result += tmp;
    tmp = b << 5;
    result += tmp;
    tmp = b << 2;
    result += tmp;

    tmp = c << 16;
    result += tmp;
    tmp = c << 15;
    result += tmp;
    tmp = c << 14;
    result += tmp;
    tmp = c << 9;
    result += tmp;
    tmp = c << 7;
    result += tmp;
    tmp = c << 4;
    result += tmp;

    result = result >> 20;

    test[i] = result;
    test[i + 1] = result;
    test[i + 2] = result;
//--------------------second loop-----------------//
    result = 0, tmp = 0;
    c = (bmp[j+1]>> 8 )&0xff;
    b = (bmp[j+1]>> 16)&0xff;
    
    a = (bmp[j+1]>> 24)&0xff;
    tmp = a << 18;
    result += tmp;
    tmp = a << 15;
    result += tmp;
    tmp = a << 14;
    result += tmp;
    tmp = a << 11;
    result += tmp;
    tmp = a << 10;
    result += tmp;
    tmp = a << 7;
    result += tmp;
    tmp = a << 6;
    result += tmp;
    tmp = a << 3;
    result += tmp;
    tmp = a << 2;
    result += tmp;
    result += a;

    tmp = b << 19;
    result += tmp;
    tmp = b << 16;
    result += tmp;
    tmp = b << 14;
    result += tmp;
    tmp = b << 13;
    result += tmp;
    tmp = b << 12;
    result += tmp;
    tmp = b << 7;
    result += tmp;
    tmp = b << 5;
    result += tmp;
    tmp = b << 2;
    result += tmp;

    tmp = c << 16;
    result += tmp;
    tmp = c << 15;
    result += tmp;
    tmp = c << 14;
    result += tmp;
    tmp = c << 9;
    result += tmp;
    tmp = c << 7;
    result += tmp;
    tmp = c << 4;
    result += tmp;

    result = result >> 20;

    test[i + 3] = result;
    test[i + 4] = result;
    test[i + 5] = result;
    // 3rd loop
    result = 0, tmp = 0;
    c = (bmp[j+2]>> 0 )&0xff;
    b = (bmp[j+2]>> 8)&0xff;
    a = (bmp[j+2]>> 16)&0xff;
    tmp = a << 18;
    result += tmp;
    tmp = a << 15;
    result += tmp;
    tmp = a << 14;
    result += tmp;
    tmp = a << 11;
    result += tmp;
    tmp = a << 10;
    result += tmp;
    tmp = a << 7;
    result += tmp;
    tmp = a << 6;
    result += tmp;
    tmp = a << 3;
    result += tmp;
    tmp = a << 2;
    result += tmp;
    result += a;

    tmp = b << 19;
    result += tmp;
    tmp = b << 16;
    result += tmp;
    tmp = b << 14;
    result += tmp;
    tmp = b << 13;
    result += tmp;
    tmp = b << 12;
    result += tmp;
    tmp = b << 7;
    result += tmp;
    tmp = b << 5;
    result += tmp;
    tmp = b << 2;
    result += tmp;

    tmp = c << 16;
    result += tmp;
    tmp = c << 15;
    result += tmp;
    tmp = c << 14;
    result += tmp;
    tmp = c << 9;
    result += tmp;
    tmp = c << 7;
    result += tmp;
    tmp = c << 4;
    result += tmp;

    result = result >> 20;

    test[i + 6] = result;
    test[i + 7] = result;
    test[i + 8] = result;
    // 4th loop
    result = 0, tmp = 0;
    c = (bmp[j+2]>> 24 )&0xff;
    b = (bmp[j+3]>> 0)&0xff;
    a = (bmp[j+3]>> 8)&0xff;
    tmp = a << 18;
    result += tmp;
    tmp = a << 15;
    result += tmp;
    tmp = a << 14;
    result += tmp;
    tmp = a << 11;
    result += tmp;
    tmp = a << 10;
    result += tmp;
    tmp = a << 7;
    result += tmp;
    tmp = a << 6;
    result += tmp;
    tmp = a << 3;
    result += tmp;
    tmp = a << 2;
    result += tmp;
    result += a;

    tmp = b << 19;
    result += tmp;
    tmp = b << 16;
    result += tmp;
    tmp = b << 14;
    result += tmp;
    tmp = b << 13;
    result += tmp;
    tmp = b << 12;
    result += tmp;
    tmp = b << 7;
    result += tmp;
    tmp = b << 5;
    result += tmp;
    tmp = b << 2;
    result += tmp;

    tmp = c << 16;
    result += tmp;
    tmp = c << 15;
    result += tmp;
    tmp = c << 14;
    result += tmp;
    tmp = c << 9;
    result += tmp;
    tmp = c << 7;
    result += tmp;
    tmp = c << 4;
    result += tmp;

    result = result >> 20;

    test[i + 9] = result;
    test[i + 10] = result;
    test[i + 11] = result;

    j= j + 3;
  }
  return 0;
}