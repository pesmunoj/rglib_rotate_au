
class rglib_rotate_tb_env extends uvm_env;
    // ------------Setup & local variables/objects------------
    // Registration of class with the uvm factory
    `uvm_component_utils(rglib_rotate_tb_env);

    // Local objects
    reset_agent_base             reset_agt;
    rglib_rotate_agent           rotate_agt;
    rglib_rotate_tb_scoreboard   sb;
    rglib_rotate_tb_coverage_cg     cov;

    // Overloading of new method for uvm_env
    function new(string name = "rglib_rotate_tb_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // ------------------BUILD_PHASE--------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        reset_agt  = reset_agent_base           :: type_id :: create("reset_agt",    this);
        rotate_agt = rglib_rotate_agent         :: type_id :: create("rotate_agt", this);
        sb         = rglib_rotate_tb_scoreboard :: type_id :: create("sb",        this);
        cov        = rglib_rotate_tb_coverage_cg:: type_id :: create("cov",       this);
    endfunction

    // ------------------CONNECT_PHASE--------------------------
    function void connect_phase(uvm_phase phase);
        // agent's monitor with scoreboard
        rotate_agt.mon.item_collect_port_in .connect(sb.item_collect_port_in);
        rotate_agt.mon.item_collect_port_out.connect(sb.item_collect_port_out);

        // agent's monitor with coverage
        rotate_agt.mon.item_collect_port_in .connect(cov.item_collect_port_in);
        rotate_agt.mon.item_collect_port_out.connect(cov.item_collect_port_out);
    endfunction
endclass
