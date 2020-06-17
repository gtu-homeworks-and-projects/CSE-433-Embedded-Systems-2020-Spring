module number_analyzer(in_number, clock, reset, enable, out_ready, is_odd, is_fibonacci, is_palindrome);
input clock;
input reset;
input enable;
input [31:0] in_number; 
output wire out_ready;
output wire is_odd;
output wire is_fibonacci;
output wire is_palindrome;

wire odd_ready;
wire fib_ready;
wire pal_ready;

odd_number_analyzer ona(in_number[0], clock, reset, enable, odd_ready, is_odd);
fib_number_analyzer fna(in_number, clock, reset, enable, fib_ready, is_fibonacci);
pal_number_analyzer pna(in_number, clock, reset, enable, pal_ready, is_palindrome);

assign out_ready = odd_ready & fib_ready & pal_ready;

endmodule