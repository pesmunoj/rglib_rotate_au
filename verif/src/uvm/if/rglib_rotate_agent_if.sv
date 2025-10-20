
`ifndef RGLIB_ROTATE_MAX_DATA_WIDTH
    `define RGLIB_ROTATE_MAX_DATA_WIDTH 1024
`endif

`ifndef RGLIB_ROTATE_MAX_ROTATE_STAGE_NUM
    `define RGLIB_ROTATE_MAX_ROTATE_STAGE_NUM 9
`endif

// -----------------INTERFACE-----------------
interface rglib_rotate_agent_if
(
  input logic clk,
  input logic kill
);
    // DUT input
    logic                                          in_valid;
    logic [`RGLIB_ROTATE_MAX_DATA_WIDTH-1:0]       in;
    logic [`RGLIB_ROTATE_MAX_ROTATE_STAGE_NUM-1:0] rotate_val;

    // DUT output
    logic  		                                   out_valid;
    logic [`RGLIB_ROTATE_MAX_DATA_WIDTH-1:0]       out;
endinterface : rglib_rotate_agent_if
