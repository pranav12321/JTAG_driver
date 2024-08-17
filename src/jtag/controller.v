//////////////////////////////////////////////////////////////////////
////                                                              ////
////  controller.v                                                ////
////  JTAG TAP controller FSM IEEE 1149.1 spec                    ////
////                                                              ////
////  Author(s):                                                  ////
////      - Pranav Rama (pranavrama222@gmail.com)                 ////
////      - Matthew Yu (matthewjkyu@gmail.com)
                                                                  ////
`include "timescale.v"

module tap_controller(TCK, TMS, TDI, TDO, Reset, controller_in_bit);

input       TCK, TMS, TDI;
output      TDO;

input       Reset;            // Reset signal

reg   [3:0] State;
input controller_in_bit;
reg [31:0] DR;
reg [31:0] IR;

wire clock_ir, update_ir, shift_ir, reset, select, enable;

always @ (posedge TCK)
begin
  case(State):
    //Test-Logic Reset
    4'b0000 :   begin
        if(controller_in_bit==0)
            State <= 1;
    end
    //Run-Test/Idle
    4'b0001 :   begin
        if(controller_in_bit==1)
            State <= 2;
    end
    //Select-DR Scan
    4'b0010 :   begin
        if(controller_in_bit==0)
            State <= 4'b0011;
        else
            State <= 9;
    end
    //Capture-DR
    4'b0011 :   begin
        if(controller_in_bit==0)
            State <= 4;
        else
            State <= 5;
    end
    //Shift-DR
    4'b0100 :   begin
        if(controller_in_bit==1)
            State <= 4'b0005;
    end
    //Exit 1-DR
    4'b0101 :   begin
        if(controller_in_bit==0)
            State <= 4'b0110;
        else
            State <= 8;
    end
    //Pause-DR
    4'b0110 :   begin
        if(controller_in_bit==1)
            State <= 4'b0111;
    end
    //Exit 2-DR
    4'b0111 :   begin
        if(controller_in_bit==1)
            State <= 4'b1000;
        else
            State <= 4;
    end
    //Update DR
    4'b1000 :   begin
        if(controller_in_bit==1)
            State <= 4'b0010;
        else
            State <= 1;
    end
    //Select-IR-Scan
    4'b1001 :   begin
        if(controller_in_bit==0)
            State <= 10;
        else
            State <= 0;
    end
    //Capture-IR
    4'b1010 :   begin
        if(controller_in_bit==0)
            State <= 11;
        else
            State <= 12;
    end
    //Shift-IR
    4'b1011 :   begin
        if(controller_in_bit==1)
            State <= 12;
    end
    //Exit1-IR
    4'b1100 :   begin
        if(controller_in_bit==0)
            State <= 13;
        else
            State <= 4'b1111;
    end
    //Pause-IR
    4'b1101 :   begin
        if(controller_in_bit==1)
            State <= 14;
    end
    //Exit2-IR
    4'b1110 :   begin
        if(controller_in_bit==0)
            State <= 11;
        else
            State <= 15;
    end
    //Update-IR
    4'b1111 :   begin
        if(controller_in_bit==0)
            State <= 10;
        else
            State <= 0;
    end
    default :   
  endcase
end

endmodule


