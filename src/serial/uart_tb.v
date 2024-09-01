`timescale 1ns / 1ns
`include "uart.v"

module UART_RX_tb ();
reg clk;
wire[7:0] RX_data;
reg RX_bit;
UART_RX rx_inst (clk, RX_data, RX_bit);
initial begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, UART_RX_tb);

    clk = 0;
    #200
    RX_bit = 1;
    #200
    RX_bit = 0;
    #200
    RX_bit = 1;
    #200
    RX_bit = 1;
    #200
    RX_bit = 0;
    #200
    RX_bit = 1;
    #200
    RX_bit = 1;
    #200
    RX_bit = 0;
    #200
    RX_bit = 1;
    #200
    RX_bit = 1;

end

// always @ (posedge enable ) begin
always begin
    #100 clk = 1;
    #100 clk = 0;
end

initial #5000ns $finish;
// end
endmodule