module rglib_rotate #(
        parameter DATA_WIDTH = 32,
        parameter POW_GRANULARITY = 0,
        parameter ROTATE_DIRECTION = "RIGHT",
        parameter ROTATE_STAGE_NUM = $clog2(DATA_WIDTH)-POW_GRANULARITY,
        parameter OUT_REG = "TRUE"
)(
        input logic                                 clk,
        input logic                                 kill,

        input logic                                 in_valid,
        input logic     [DATA_WIDTH-1:0]            in,
        input logic     [ROTATE_STAGE_NUM-1:0]      rotate_val,

        output logic                                out_valid,
        output logic    [DATA_WIDTH-1:0]            out
);
endmodule
