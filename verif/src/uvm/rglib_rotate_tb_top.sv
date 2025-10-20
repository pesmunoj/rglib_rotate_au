
`timescale 1ns/1ns

import uvm_pkg::*;         // [UVM] package
`include "uvm_macros.svh"  // [UVM] package

import rglib_rotate_tb_pkg::*;
import rglib_rotate_params_pkg::*;

module rglib_rotate_tb_top();

    rglib_rotate_clk_if clk_if();

    // Create reset interface object
    reset_if reset_if( .clk ( clk_if.clk ) );

    // Create main interface object
    rglib_rotate_agent_if_wrapper #(
        .DATA_WIDTH      ( RGLIB_ROTATE_DATA_WIDTH       ),
        .ROTATE_STAGE_NUM( RGLIB_ROTATE_ROTATE_STAGE_NUM )
    ) agt_if (
        .clk ( clk_if.clk       ),
        .kill( reset_if.reset )
    );

    rglib_rotate_coverage_sva rglib_rotate_coverage_sva (
        .clk      (clk_if.clk),
        .reset    (reset_if.reset),
        .in_valid (agt_if.in_valid),
        .out_valid(agt_if.out_valid)
    );

    // Create DUT object
    rglib_rotate #(
        .DATA_WIDTH      ( RGLIB_ROTATE_DATA_WIDTH       ),
        .POW_GRANULARITY ( RGLIB_ROTATE_POW_GRANULARITY  ),
        .ROTATE_STAGE_NUM( RGLIB_ROTATE_ROTATE_STAGE_NUM ),
        .ROTATE_DIRECTION( RGLIB_ROTATE_ROTATE_DIRECTION ),
        .OUT_REG         ( RGLIB_ROTATE_OUT_REG          )
    ) DUT (
        .clk       ( clk_if.clk        ),
        .kill      ( reset_if.reset  ),

        .in_valid  ( agt_if.in_valid   ),
        .in        ( agt_if.in         ),
        .rotate_val( agt_if.rotate_val ),

        .out_valid ( agt_if.out_valid  ),
        .out       ( agt_if.out        )
    );

    //***************************************************
    //                  START TEST
    //***************************************************
    // Set interface & DUT parameter in uvm_config_db
    initial begin
    $display({"DUT PARAMETERS:",RGLIB_ROTATE_DATA_WIDTH, RGLIB_ROTATE_POW_GRANULARITY, RGLIB_ROTATE_ROTATE_STAGE_NUM, RGLIB_ROTATE_ROTATE_DIRECTION, RGLIB_ROTATE_OUT_REG});
      // send all interfaces to their designated agents
      uvm_config_db#(virtual reset_if)             ::set(null, "*reset_agt", "vif", reset_if);
      uvm_config_db#(virtual rglib_rotate_agent_if)::set(null, "*rotate_agt","vif", agt_if.intf);

      fork
        clk_if.start_clk();
        run_test();
      join
    end

endmodule
