package rglib_rotate_agent_pkg;
    import uvm_pkg::*;              // [UVM] package
    `include "uvm_macros.svh"       // [UVM] package

    `uvm_analysis_imp_decl(_in)     // [UVM] macro
    `uvm_analysis_imp_decl(_out)    // [UVM] macro

    import rglib_rotate_tb_typedefs::*;
    import rglib_rotate_params_pkg::*;

    `include "rglib_rotate_agent_seq_item.sv"

    `include "rglib_rotate_agent_cfg.sv"

    `include "rglib_rotate_agent_sequencer.sv"

    `include "rglib_rotate_agent_monitor.sv"

    `include "rglib_rotate_agent_driver.sv"

    `include "rglib_rotate_agent_seqc_lib.sv"

    `include "rglib_rotate_agent.sv"
endpackage
