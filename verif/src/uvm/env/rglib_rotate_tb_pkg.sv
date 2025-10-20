
package rglib_rotate_tb_pkg;

    import uvm_pkg::*;         // [UVM] package
    `include "uvm_macros.svh"  // [UVM] package

    // DUT PARAMETERS pkg file
    import rglib_rotate_params_pkg::*;
    import rglib_rotate_tb_typedefs::*;

    // Reset agent & sequence pkg file
    import reset_agent_pkg::*;

    // RGlib_rotate_agent
    import rglib_rotate_agent_pkg::*;

    `include "rglib_rotate_tb_coverage_cg.sv"

    `include "rglib_rotate_tb_scoreboard.sv"

    `include "rglib_rotate_tb_env.sv"

    `include "rglib_rotate_tb_test_lib.sv"

endpackage
