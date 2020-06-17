module number_analyzer_tb;
	reg[31:0] in_number;
	reg clock;
	reg reset;
	reg enable;
	
	reg [31:0] test_numbers[4:0];
	reg [4:0] test_numbers_index = 0;
	wire is_odd;
	wire is_fib;
	wire is_pal;
	wire all_ready;
	 
	number_analyzer na(in_number, clock, reset, enable, all_ready, is_odd, is_fib, is_pal);
	
	initial begin
		$monitor("Time: %3d \tNumber: %10d, Is Odd: %d, Is Fibonacci: %d, Is Palindrome: %d, Output Ready: %d", $time, in_number, is_odd, is_fib, is_pal, all_ready);
		in_number = 0;
		clock = 0;
		enable = 1;
		reset = 0;
		test_numbers[0] = 1346269;
		test_numbers[1] = 1187811;
		test_numbers[2] = 832040;
		test_numbers[3] = 13469;
		test_numbers[4] = 1669;
		forever #5 clock = ~clock;
	end

	always @(posedge all_ready) begin
		if (all_ready & test_numbers_index < 5) begin
			#200
			in_number = test_numbers[test_numbers_index];
			reset = 1;
			#10 reset = 0;
			test_numbers_index = test_numbers_index + 1;
		end
	end

endmodule