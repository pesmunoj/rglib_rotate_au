
//-----------------INTERFACE WRAPPER-----------------
interface rglib_rotate_agent_if_wrapper #(
    parameter DATA_WIDTH = 32,
    parameter ROTATE_STAGE_NUM = 1
)(
    input logic  clk,
    input logic  kill
);
    // DUT input
    logic                        in_valid;
    logic [DATA_WIDTH-1:0]       in;
    logic [ROTATE_STAGE_NUM-1:0] rotate_val;

    // DUT output
    logic  		                 out_valid;
    logic [DATA_WIDTH-1:0]       out;

    // Maximum-footprint intf, used by agents
    rglib_rotate_agent_if intf( .clk( clk ), .kill( kill ) );

    //------Connect wrapper to maximum-footprint intf------
    assign in_valid      = intf.in_valid;
    assign in            = intf.in         [DATA_WIDTH       -1:0];
    assign rotate_val    = intf.rotate_val [ROTATE_STAGE_NUM -1:0];

    assign intf.out_valid            = out_valid;
    assign intf.out [DATA_WIDTH-1:0] = out;
endinterface : rglib_rotate_agent_if_wrapper
