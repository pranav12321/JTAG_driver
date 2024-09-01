//////////////////////////////////////////////////////////////////////
////                                                              ////
//// uart.v                                                       ////
//// UART modules and controller  1-8-1 no parity                 ////
////                                                              ////
////  Author(s):                                                  ////
////      - Pranav Rama (pranavrama222@gmail.com)                 ////
////      - Matthew Yu (matthewjkyu@gmail.com)
                                                                  ////
 
module UART_RX (CLK, RX_data, RX_bit);

input CLK, RX_bit;
output [7:0] RX_data;
reg [7:0] RX_shift;
reg [15:0] RX_FIFO[7:0];
reg [3:0] rx_bit_ctr;
reg [3:0] rx_fifo_ctr;
wire we;

initial begin
    rx_bit_ctr = 0;
    rx_fifo_ctr = 0;
    RX_shift = 0;
end

assign we = !((RX_bit == 1) && (rx_bit_ctr == 9));

wire fifo_full, fifo_empty;

fifo #(.SIZE(8)) fifo_inst (CLK, RX_data, RX_shift, we, fifo_full, fifo_empty);

always @ (posedge CLK)
begin
    if((RX_bit == 1) && (rx_bit_ctr == 0)) begin//Should be 1 for valid start bit
        rx_bit_ctr <= rx_bit_ctr + 1;
    end
    else if(rx_bit_ctr == 9) begin //Stop check condition
        rx_bit_ctr <= 0;
    end
    else if(rx_bit_ctr > 0) begin
        rx_bit_ctr <= rx_bit_ctr + 1;
        RX_shift <= (RX_shift << 1) + RX_bit; //init RX_shift to 0 on reset
    end
end


endmodule

module UART_TX (CLK, TX_data);
input CLK;
input [7:0] TX_data;
endmodule

//Control FSM to interface between CPU bus and UART module
//Also contains user peripheral register interface
module UART_Controller();
endmodule

module fifo #(parameter SIZE=8)(clk, read_data, write_data, we, fifo_full, fifo_empty);
reg [7:0] RX_FIFO[0:7];
reg[3:0] head;
reg[3:0] tail; 
input we, clk;
input [7:0] write_data;
output fifo_full, fifo_empty;
output wire[7:0] read_data;
assign read_data = RX_FIFO[head];

assign fifo_empty = (head==tail);
assign fifo_full = (head == (tail+1'b1));

initial begin
    head = 0;
    tail = 0;
end

always @ (posedge clk)
begin
    if((we==0) && (!fifo_full)) begin
        RX_FIFO[tail] <= write_data;
        tail <= tail+1;
    end
end

always @ (posedge clk)
begin
    if((we==0) && (!fifo_full)) begin
        RX_FIFO[tail] <= write_data;
        tail <= tail+1;
    end
end

endmodule
 
