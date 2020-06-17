module odd_number_analyzer(in_number, clock, reset, enable, out_ready, is_odd);
input clock;
input reset;
input enable;
input in_number; 
output reg out_ready;
output reg is_odd;

reg num;

parameter  
	S0=2'b00, // Initial/Reset State
	S1=2'b01, // Condition check State
	S2=2'b10, // Odd State
	S3=2'b11; // Even State
reg [1:0] current_state = S0, next_state;

always @(posedge clock, posedge reset)
begin
	if(reset)
		current_state <= S0;
	else if (enable == 0)
		current_state <= S0;
	else
		current_state <= next_state;
end

// Next state logic
always @(current_state, num)
begin
	case(current_state) 
		S0: begin
			next_state <= S1;
		end
		S1: begin
			if(num)
				next_state <= S2; 
			else
				next_state <= S3;
		end
		S2: begin // ODD STATE
			next_state <= current_state;
		end
		S3: begin // EVEN STATE
			next_state <= current_state;
		end
		default:
			next_state <= S0;
	endcase
end

always @(current_state)
begin 
	case(current_state)
		S0: begin 
			num <= in_number;
			out_ready <= 0;
		end
		S2: begin
			out_ready <= 1;
			is_odd <= 1;
		end
		S3: begin 
			out_ready <= 1;
			is_odd <= 0;
		end
		default: begin
			out_ready <= 0;
			is_odd <=0;
		end
	endcase
end 

endmodule