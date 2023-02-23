

#include <stdint.h>

#include <stdbool.h>

#include "inc/hw_types.h"

#include "inc/hw_gpio.h"

#include "driverlib/pin_map.h"

#include "inc/hw_memmap.h"

//#include "driverlib/sysctl.c"
//
#include "driverlib/sysctl.h"

//#include "driverlib/gpio.c"

#include "driverlib/gpio.h"

#include "driverlib/timer.h"

#include "math.h"

#include "driverlib/adc.h"

#include "driverlib/uart.h"
#include "driverlib/rom.h"

#define JTAG_TCK_PORT GPIO_PORTE_BASE
#define JTAG_TCK_PIN GPIO_PIN_0
#define JTAG_TMS_PORT GPIO_PORTE_BASE
#define JTAG_TMS_PIN GPIO_PIN_1
#define JTAG_TDI_PORT GPIO_PORTE_BASE
#define JTAG_TDI_PIN GPIO_PIN_2
#define JTAG_TDO_PORT GPIO_PORTE_BASE
#define JTAG_TDO_PIN GPIO_PIN_3

#define JTAG_TCK_HALF_PERIOD_DELAY 600000


// Global variables
uint8_t boundary_scan_buffer[121];

void JTAG_clock_pulse(){
    GPIOPinWrite(JTAG_TCK_PORT, JTAG_TCK_PIN, JTAG_TCK_PIN);
    SysCtlDelay(JTAG_TCK_HALF_PERIOD_DELAY);

    GPIOPinWrite(JTAG_TCK_PORT, JTAG_TCK_PIN, 0);
    SysCtlDelay(JTAG_TCK_HALF_PERIOD_DELAY);
}

void set_TMS_high(){
    GPIOPinWrite(JTAG_TMS_PORT, JTAG_TMS_PIN, JTAG_TMS_PIN);
}

void set_TMS_low(){
    GPIOPinWrite(JTAG_TMS_PORT, JTAG_TMS_PIN, 0);
}

void set_TDI_high(){
    GPIOPinWrite(JTAG_TDI_PORT, JTAG_TDI_PIN, JTAG_TDI_PIN);
}

void set_TDI_low(){
    GPIOPinWrite(JTAG_TDI_PORT, JTAG_TDI_PIN, 0);
}

void reset_controller(){
    int i;
    set_TMS_high();
    for(i = 0; i<5; i++){
        JTAG_clock_pulse();
    }
}

int find_num_devices(){
   return 0;
}

void perform_boundary_scan(){
    int i;

    reset_controller();

    // go to Shift-IR
    set_TMS_low();
    JTAG_clock_pulse();
    set_TMS_high();
    JTAG_clock_pulse();
    set_TMS_high();
    JTAG_clock_pulse();
    set_TMS_low();
    JTAG_clock_pulse();
    set_TMS_low();
    JTAG_clock_pulse();


    // IR is 4 bits long,
    // and that SAMPLE code = 0010b
    set_TDI_low();
    JTAG_clock_pulse();
    set_TDI_high();
    JTAG_clock_pulse();
    set_TDI_low();
    JTAG_clock_pulse();
    set_TDI_low();
    set_TMS_high();
    JTAG_clock_pulse();

    // we are in Exit1-IR, go to Shift-DR
    set_TMS_high();
    JTAG_clock_pulse();
    set_TMS_high();
    JTAG_clock_pulse();
    set_TMS_low();
    JTAG_clock_pulse();
    set_TMS_low();
    JTAG_clock_pulse();



    for(i = 0; i< 121; i++){
        JTAG_clock_pulse();
        int tdo = GPIOPinRead(JTAG_TDO_PORT, JTAG_TDO_PIN);
        boundary_scan_buffer[i] = (tdo > 0) ? 1 : 0;
    }
}



int main(void)

{
    volatile uint32_t ui32Loop;
    //Set the clock to 80Mhz
    SysCtlClockSet(
    SYSCTL_SYSDIV_2_5 | SYSCTL_USE_PLL | SYSCTL_OSC_MAIN | SYSCTL_XTAL_16MHZ);

    /*
     Enable peripheral clocks
     */
    SysCtlPeripheralEnable(PERIPH_A);
    SysCtlDelay(3);
    SysCtlPeripheralEnable(PERIPH_B);
    SysCtlDelay(3);
    SysCtlPeripheralEnable(PERIPH_C);
    SysCtlDelay(3);
    SysCtlPeripheralEnable(PERIPH_D);
    SysCtlDelay(3);
    SysCtlPeripheralEnable(PERIPH_E);
    SysCtlDelay(3);
    SysCtlPeripheralEnable(PERIPH_F);
    SysCtlDelay(3);
    SysCtlPeripheralEnable(PERIPH_N);
    SysCtlDelay(3);
    SysCtlPeripheralEnable(PERIPH_ADC);
    SysCtlDelay(3);
//    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);

    //Set the clock to 80Mhz

    GPIOPinTypeGPIOOutput(GPIO_PORTN_BASE, GPIO_PIN_1);
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_4);
    GPIOPinTypeGPIOOutput(JTAG_TDI_PORT, JTAG_TDI_PIN);
    GPIOPinTypeGPIOOutput(JTAG_TMS_PORT, JTAG_TMS_PIN);
    GPIOPinTypeGPIOOutput(JTAG_TCK_PORT, JTAG_TCK_PIN);
    GPIOPinTypeGPIOInput(JTAG_TDO_PORT, JTAG_TDO_PIN);

    GPIOPinWrite(JTAG_TCK_PORT, JTAG_TCK_PIN, 0);
    GPIOPinWrite(JTAG_TMS_PORT, JTAG_TMS_PIN, 0);
    GPIOPinWrite(JTAG_TDI_PORT, JTAG_TDI_PIN, 0);

    while (1)

    {
        GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, 2);
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, 16);
        SysCtlDelay(600000);

        GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, 0);
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, 0);

        SysCtlDelay(600000);

    }

}
