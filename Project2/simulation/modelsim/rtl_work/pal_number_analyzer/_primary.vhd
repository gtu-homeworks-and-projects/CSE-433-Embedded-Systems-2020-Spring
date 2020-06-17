library verilog;
use verilog.vl_types.all;
entity pal_number_analyzer is
    generic(
        S0              : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        S1              : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        S2              : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        S3              : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        S4              : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0);
        S5              : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1);
        S6              : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1)
    );
    port(
        in_number       : in     vl_logic_vector(31 downto 0);
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        out_ready       : out    vl_logic;
        is_pal          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of S0 : constant is 1;
    attribute mti_svvh_generic_type of S1 : constant is 1;
    attribute mti_svvh_generic_type of S2 : constant is 1;
    attribute mti_svvh_generic_type of S3 : constant is 1;
    attribute mti_svvh_generic_type of S4 : constant is 1;
    attribute mti_svvh_generic_type of S5 : constant is 1;
    attribute mti_svvh_generic_type of S6 : constant is 1;
end pal_number_analyzer;
