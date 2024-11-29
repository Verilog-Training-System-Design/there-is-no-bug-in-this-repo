#include <stdint.h>

#define MIP_MEIP (1 << 11) // External interrupt pending
#define MIP_MTIP (1 << 7)  // Timer interrupt pending
#define MIP 0x344

extern unsigned int _binary_image_bmp_start
extern unsigned int _binary_image_bmp_end
extern unsigned int _binary_image_bmp_size

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

float Grayscale(int8_t B, int8_t G, int8_t R){
    float Gray_result;


    
    Gray_result = 0.11* B + 0.59* G +0.3* R;
    return Gray_result;
}
int main() {
    int data_get;
    int8_t B;
    int8_t G;
    int8_t R;

    for(data_get = 54; data_get < &; data_get += 3){
        B   = (&_binary_image_bmp_start)[data_get];
        G   = (&_binary_image_bmp_start)[data_get + 1];
        R   = (&_binary_image_bmp_start)[data_get + 2];
        Grayscale(B, G, R);
    }

    //result address
    extern float _test_start;
    for(){
    *(&_test_start)[i]  =   Grayscale(B, G, R);
    }
    return 0;
}
