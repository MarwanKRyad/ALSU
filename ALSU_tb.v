
module ALSU_tb(); 
 reg [2:0] A,B,OPCODE;
 reg RED_OP_A,RED_OP_B,SERIAL_IN,DIRECTION,BYPASSA,BYPASSB,rst,clk,CIN;
 reg [5:0]expected_OUT;
 reg [15:0]expected_LEDS;

wire [5:0]OUT;
wire [15:0]LEDS;
ALSU DUT(A,B,OPCODE,CIN,SERIAL_IN,DIRECTION,RED_OP_A,RED_OP_B,BYPASSA,BYPASSB,rst,clk,OUT,LEDS);
initial begin
	clk=0;
	forever 
	#1 clk=~clk;		
end


initial
begin
A=1; B=1; OPCODE=2; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=1; 
expected_OUT=0; expected_LEDS=0; // reset case
#2
A=1; B=1; OPCODE=6; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=0; expected_LEDS=16'b1111111111111111; // invalid opcode
#2

A=1; B=1; OPCODE=7; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=0; expected_LEDS=0; // invalid opcode
#2

A=1; B=2; OPCODE=3; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=1; BYPASSB=0; rst=0; 
expected_OUT=1; expected_LEDS=0; // pass a
#2
A=1; B=2; OPCODE=3; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=1; rst=0; 
expected_OUT=2; expected_LEDS=0; // pass b
#2
A=1; B=2; OPCODE=3; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=1; BYPASSB=1; rst=0; 
expected_OUT=1; expected_LEDS=0; // pass a due INPUT_PRIORITY

A=1; B=7; OPCODE=0; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=1; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=0; expected_LEDS=0; // reduc and a
#2

A=1; B=7; OPCODE=0; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=1; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=1; expected_LEDS=0; // reduc and b
#2

A=1; B=7; OPCODE=0; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=1; RED_OP_B=1; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=0; expected_LEDS=0; // reduc and a due INPUT_PRIORITY
#2

A=1; B=7; OPCODE=0; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=1; expected_LEDS=0; // a &b 
#2


A=0; B=1; OPCODE=1; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=1; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=0; expected_LEDS=0; // reduc xor a
#2

A=0; B=1; OPCODE=1; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=1; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=1; expected_LEDS=0; // reduc xor b
#2

A=0; B=1; OPCODE=1; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=1; RED_OP_B=1; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=0; expected_LEDS=0; // reduc a due INPUT_PRIORITY
#2

A=0; B=1; OPCODE=1; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=1; expected_LEDS=0; // a^b
#2


A=3; B=2; OPCODE=3; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=6; expected_LEDS=0; // a*b 
#2



A=1; B=1; OPCODE=4; CIN=1; SERIAL_IN=0; DIRECTION=1; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=6'b001100; expected_LEDS=0; // out<<1 
#2


A=1; B=1; OPCODE=4; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=6; expected_LEDS=0; // out>>1 
#2


A=1; B=1; OPCODE=5; CIN=1; SERIAL_IN=0; DIRECTION=1; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=6'b001100; expected_LEDS=0; // out Rot left 1 
#2



A=1; B=1; OPCODE=5; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=6; expected_LEDS=0; // out Rot Right 1  


A=1; B=1; OPCODE=2; CIN=1; SERIAL_IN=0; DIRECTION=0; RED_OP_A=0; RED_OP_B=0; BYPASSA=0; BYPASSB=0; rst=0; 
expected_OUT=3; expected_LEDS=0; // a+b+cin 


end

endmodule





