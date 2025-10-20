/**************************************************************************************************
 *                                                                                                *
 *  File Name:     rglib_rotate.sv                                                                *
 *                                                                                                *
 **************************************************************************************************
 *                                                                                                *
 *  Description:                                                                                  *
 *   Rotator                                                                                      *
 *                                                                                                *
 **************************************************************************************************
 *  System Verilog code                                                                           *
 **************************************************************************************************/
(* keep_hierarchy = "yes" *)

module rglib_rotate #(
        parameter DATA_WIDTH = 32,
        parameter POW_GRANULARITY = 0,
        parameter ROTATE_DIRECTION = "RIGHT",
        parameter ROTATE_STAGE_NUM = $clog2(DATA_WIDTH)-POW_GRANULARITY,
        parameter OUT_REG = "TRUE"
)
    (
        input logic                         clk,
        input logic                         kill,

        input logic                         in_valid,
        input logic     [DATA_WIDTH-1:0]    in,
        input logic     [ROTATE_STAGE_NUM-1:0]     rotate_val,

        output logic                        out_valid,
        output logic    [DATA_WIDTH-1:0]    out
    );

/* Internal regs */

  logic [DATA_WIDTH-1:0] rot_stage[0:ROTATE_STAGE_NUM-1];

  genvar i;
/* rotate logic */

// Right rotate logic
if(ROTATE_DIRECTION == "RIGHT") begin
    assign rot_stage[0] = rotate_val[0] ? {{(POW_GRANULARITY)'(in)}, {(DATA_WIDTH-POW_GRANULARITY)'(in >> POW_GRANULARITY)}} : in;

    for(i = 1; i < ROTATE_STAGE_NUM; i++) begin
        assign rot_stage[i] = rotate_val[i] ? {{(POW_GRANULARITY*2**i)'(rot_stage[i-1])}, {(DATA_WIDTH-POW_GRANULARITY*2**i)'(rot_stage[i-1] >> POW_GRANULARITY*2**i)}} : rot_stage[i-1];
    end
end
else begin
    assign rot_stage[0] = rotate_val[0] ? {{(DATA_WIDTH-POW_GRANULARITY)'(in)}, {(POW_GRANULARITY)'(in >> (DATA_WIDTH - POW_GRANULARITY))}} : in;

    for(i = 1; i < ROTATE_STAGE_NUM; i++) begin
        assign rot_stage[i] = rotate_val[i] ? {{(DATA_WIDTH-POW_GRANULARITY*2**i)'(rot_stage[i-1])}, {(POW_GRANULARITY*2**i)'(rot_stage[i-1] >> (DATA_WIDTH - POW_GRANULARITY*2**i))}} : rot_stage[i-1];
    end
end

if(OUT_REG == "TRUE") begin
    always_ff @(posedge clk) begin
        out_valid   <= in_valid;
        out         <= rot_stage[ROTATE_STAGE_NUM-1];
    end
end
else begin
    assign out_valid    = in_valid;
    assign out          = rot_stage[ROTATE_STAGE_NUM-1];
end

endmodule : rglib_rotate
