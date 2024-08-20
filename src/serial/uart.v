//////////////////////////////////////////////////////////////////////
////                                                              ////
//// uart.v                                                       ////
//// UART modules and controller  1-8-1 no parity                 ////
////                                                              ////
////  Author(s):                                                  ////
////      - Pranav Rama (pranavrama222@gmail.com)                 ////
////      - Matthew Yu (matthewjkyu@gmail.com)
                                                                  ////
 
module UART_RX (CLK, RX_data);

input CLK;
input RX_data;
reg [7:0] RX_shift;
reg [15:0][7:0] RX_FIFO;
reg [2:0] rx_bit_ctr;
reg [3:0] rx_fifo_ctr;

always @ (posedge TCK)
begin
    if((RX_data == 1) && (rx_bit_ctr == 0)) //Should be 1 for valid start bit
        rx_bit_ctr <= rx_bit_ctr + 1;
    else if(rx_bit_ctr == 9) begin //Stop check condition
        rx_bit_ctr <= 0;
        if(RX_data == 1) begin
            RX_FIFO[rx_fifo_ctr] <= RX_shift;
            rx_fifo_ctr <= rx_fifo_ctr+1; //Just an outline; Should do Overflow check; cyclic buffer; basically need a fifo module
        end
    end
    else if(rx_bit_ctr > 0) begin
        rx_bit_ctr <= rx_bit_ctr + 1;
        RX_shift <= (RX_shift << 1) + RX_data; //init RX_shift to 0 on reset
    end
end


endmodule

module UART_TX (CLK, TX_data);
endmodule

//Control FSM to interface between CPU bus and UART module
//Also contains user peripheral register interface
module UART_Controller();
endmodule
 
