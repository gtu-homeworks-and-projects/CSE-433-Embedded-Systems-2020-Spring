library verilog;
use verilog.vl_types.all;
entity number_analyzer is
    port(
        in_number       : in     vl_logic_vector(31 downto 0);
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        out_ready       : out    vl_logic;
        is_odd          : out    vl_logic;
        is_fibonacci    : out    vl_logic;
        is_palindrome   : out    vl_logic
    );
end number_analyzer;
