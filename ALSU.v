module ALSU (A,B,OPCODE,CIN,SERIAL_IN,DIRECTION,RED_OP_A,RED_OP_B,BYPASSA,BYPASSB,rst,clk,OUT,LEDS);
input [2:0] A,B,OPCODE;
input RED_OP_A,RED_OP_B,SERIAL_IN,DIRECTION,BYPASSA,BYPASSB,rst,clk,CIN;

 reg [2:0] A_Q,B_Q,OPCODE_Q;
 reg CIN_Q,SERIAL_IN_Q,DIRECTION_Q,RED_OP_A_Q,RED_OP_B_Q,BYPASSA_Q,BYPASSB_Q;

output reg [5:0]OUT;
output reg [15:0]LEDS;
parameter INPUT_PRIORITY="A";

parameter full_adder="ON";
wire invalid_Op_code;
wire invalid_Operaion_2;
wire invalid_Cases;
//////////////////////////////////////////////////////////////////////
always @(posedge clk or posedge rst)   //assume the the all DFF have same clk and rst
begin
if (rst) begin
		A_Q<=0; B_Q<=0; OPCODE_Q<=0; CIN_Q<=0; SERIAL_IN_Q<=0; DIRECTION_Q<=0; 
		RED_OP_A_Q<=0; RED_OP_B_Q<=0;  BYPASSA_Q<=0; BYPASSB_Q<=0;
	end
	else begin
		A_Q<=A; B_Q<=B; OPCODE_Q<=OPCODE; CIN_Q<=CIN; SERIAL_IN_Q<=SERIAL_IN; DIRECTION_Q<=DIRECTION; 
		RED_OP_A_Q<=RED_OP_A; RED_OP_B_Q<=RED_OP_B;  BYPASSA_Q<=BYPASSA; BYPASSB_Q<=BYPASSB;
	end
end
//////////////////////////////////////////////////////////////////////////////////////////
assign  invalid_Op_code=OPCODE_Q[2]&OPCODE_Q[1];
assign invalid_Operaion_2=(OPCODE_Q[2]|OPCODE[1])&(RED_OP_A|RED_OP_B);
assign invalid_Cases=invalid_Op_code | invalid_Operaion_2;
////////////////////////////
always @(posedge clk or posedge rst)
 begin
	if (rst) 
        begin
		OUT=0; LEDS=0;
	end

////////////////////////////////////////////////
	else if(invalid_Cases==1)
	begin
		OUT=0;
		LEDS=~LEDS;
	end
////////////////////////////////////////////////////////////////////////////
	else if((INPUT_PRIORITY=="A") &(BYPASSA_Q |BYPASSB_Q ))
	begin
		if(BYPASSA_Q)
		begin OUT=A_Q; LEDS=0; end 
		else if(BYPASSB_Q)
		begin OUT=B_Q; LEDS=0; end
	end
	//////////////////////////////////////////////////////
	else if((INPUT_PRIORITY=="B") &(BYPASSA_Q |BYPASSB_Q ))
	begin
		if(BYPASSB_Q)
		begin OUT=B_Q; LEDS=0; end
		else if(BYPASSA_Q)
		begin OUT=A_Q; LEDS=0; end
	end
///////////////////////////////////////////////////////////////////////////////////////////////////////
	else 
	 begin
		case (OPCODE_Q)
		0: 
		begin 
			if(INPUT_PRIORITY=="A")
			 begin
				if(RED_OP_A_Q)
				begin	OUT=&A_Q; LEDS=0;  end
				else if(RED_OP_B_Q)
				begin OUT=&B_Q; LEDS=0;	   end
				else
				begin OUT=A_Q&B_Q;  LEDS=0; end
			end
 		

			if(INPUT_PRIORITY=="B")
			begin 
				if(RED_OP_B_Q)
					begin OUT=&B_Q; LEDS=0;	end
				else if(RED_OP_B_Q)
					begin OUT=&A_Q; LEDS=0;	end
				else 
					begin OUT=A_Q&B_Q; LEDS=0; end
			end

		end
		///////////////////////////////////////////////////////////////
		1: 
		begin	
			if(INPUT_PRIORITY=="A")
			 begin
				if(RED_OP_A_Q)
				begin	OUT=^A_Q; LEDS=0;   end
				else if(RED_OP_B_Q)
				begin 	OUT=^B_Q; LEDS=0;    end
				else
				begin   OUT=A_Q^B_Q;  LEDS=0; end
			end
 		

			if(INPUT_PRIORITY=="B")
			begin 
				if(RED_OP_B_Q)
					begin OUT=^B_Q; LEDS=0; end
				else if(RED_OP_B_Q)
					begin OUT=^A_Q; LEDS=0; end
				else
					begin OUT=A_Q^B_Q; LEDS=0; end
			end

		end
		////////////////////////////////////////////////////////////
		2:
 		begin
 			if(full_adder=="ON")
 			begin OUT=A_Q+B_Q+CIN_Q; LEDS=0; end
 			else if (full_adder=="OFF")
 			begin OUT=A_Q+B_Q; LEDS=0; end
 		end
		///////////////////////////////////////////////////////////////
 		3:
 		begin
 			 OUT=A_Q*B_Q; LEDS=0;
 		end
		///////////////////////////////////////////////////////////////
 		4:
 		begin
 			if(DIRECTION_Q==1)
 				begin OUT<=OUT<<1; LEDS=0; end
 			else 
 				begin OUT<=OUT>>1; LEDS=0; end
 		end

		///////////////////////////////////////////////////////////////
 		5:
		begin
 			if(DIRECTION_Q==1)
 				begin OUT<={OUT[4:0],OUT[5]}; LEDS=0; end
 			else 
 				begin OUT<={OUT[0],OUT[5:1]}; LEDS=0; end
 		end


		endcase
	end
end


endmodule 