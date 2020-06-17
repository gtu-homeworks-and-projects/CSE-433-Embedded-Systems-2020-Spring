module pal_number_analyzer(in_number, clock, reset, enable, out_ready, is_pal);
input clock;
input reset;
input enable;
input[31:0] in_number; 
output reg out_ready;
output reg is_pal;

parameter  
	S0=3'b000, // Initial/Reset State
	S1=3'b001, // Palindrome Calculation Control State
	S2=3'b011, // Palindrome Calculation State
	S3=3'b010, // Palindrome Check Control State
	S4=3'b110, // Palindrome Check Calculation State
	S5=3'b111, // Palindrome State
	S6=3'b101; // Non-Palindrome State
reg [2:0] current_state = S0, next_state;
reg [4:0] digits [9:0];
reg [31:0] number;
reg [4:0] total_digit_count;
reg [4:0] index;
reg [4:0] digit_index;

always @(posedge clock, posedge reset)
begin
	if(reset)
		current_state <= S0;
	else if (enable == 0)
		current_state <= S0;
	else begin
		current_state <= next_state;
	end
end

// Next state logic
always @(current_state, number, total_digit_count, index, digits)
begin
	case(current_state) 
		S0: begin
			next_state <= S1;
		end
		S1: begin // Palindrome Calculation Control State
			if($signed(number) == 0)
				next_state <= S3;
			else
				next_state <= S2;
		end
		S2: begin // Palindrome Calculation State
			next_state <= S1;
		end
		S3: begin // Palindrom Check Control State
			if (total_digit_count == 1 | digit_index <= index) next_state <= S5;
			else if (digits[digit_index - 1] == digits[index]) next_state <= S4;
			else next_state <= S6;
		end
		S4: begin // Palindrom Check Calc State
			next_state <= S3;
		end
		S5: begin // Palindrome STATE
			next_state <= current_state;
		end
		S6: begin
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
			is_pal <= 0;
			out_ready <= 0;
			total_digit_count <= 0;
			digits[0] <= 0;
			digits[1] <= 0;
			digits[2] <= 0;
			digits[3] <= 0;
			digits[4] <= 0;
			digits[5] <= 0;
			digits[6] <= 0;
			digits[7] <= 0;
			digits[8] <= 0;
			digits[9] <= 0;
			index <= 0;
			number <= in_number;
			digit_index <= 0;
		end
		S2: begin
			digits[total_digit_count] <= $signed(number) % 10;
			number <= $signed(number) / 10;
			total_digit_count <= total_digit_count + 1;
			digit_index <= total_digit_count + 1;
		end
		S4: begin 
			index <= index + 1;
			digit_index <= digit_index - 1;
		end
		S5: begin 
			out_ready <= 1;
			is_pal <= 1;
		end
		S6: begin 
			out_ready <= 1;
			is_pal <= 0;
		end
		default: begin
			out_ready <= 0;
			is_pal <=0;
		end
	endcase
end 

endmodule