
//*******************************************************************************//
//                                  Base test:                                   //
//                              Base test with 1 data                            //
//*******************************************************************************//
class base_test extends uvm_test;
        // ------------------Setup & local variables/objects------------------
        rglib_rotate_agent_cfg      rotate_agent_cfg;
        rglib_rotate_tb_env         env;
        base_seqc                   seqc;
        reset_agent_sequence_base   reset_seqc;

        // UVM command line parser.
        uvm_cmdline_processor clp;

        // The utils macros define the infrastructure needed to enable the object/component for correct factory operation.
        `uvm_component_utils(base_test);

        // Overload new() method in uvm_test
        function new(string name = "base_test", uvm_component parent = null);
            super.new(name, parent); // new operation for uvm_test
            uvm_report_info(get_full_name, "TEST: new()", UVM_DEBUG); // reporting macro
        endfunction

        // ------------------BUILD_PHASE--------------------------
        virtual function void build_phase(uvm_phase phase);
            // Create and configure of testbench structure
            super.build_phase(phase);
            // reporting macro
            uvm_report_info(get_full_name, "TEST: build()", UVM_DEBUG);

            // call factory to create env class object
            env = rglib_rotate_tb_env::type_id::create("base_env", this);

            set_cfg();
            uvm_config_db#(rglib_rotate_agent_cfg)::set(this, "*rotate_agt", "cfg", rotate_agent_cfg);
        endfunction

        // ------------------RUN_PHASE--------------------------
        virtual task run_phase(uvm_phase phase);
            // Raise the phase objection
            phase.raise_objection(this);

            // Create reset sequence
            // and get needed sequence type
            reset_seqc = reset_agent_sequence_base::type_id::create("reset_seqc");
            get_seqc(seqc);

            // Start sequences
            uvm_report_info(get_full_name, "TEST: Start testcase", UVM_DEBUG);
            run_seqc();
            #20;
            // Drop the phase objection
            uvm_report_info(get_type_name, "TEST: End testcase", UVM_DEBUG);
            phase.drop_objection(this);
        endtask

      // ------------------END_OF_ELABORATION_PHASE--------------------------
      virtual function void end_of_elaboration_phase(uvm_phase phase);
        // display topology if uvm verbosity >= UVM_MEDIUM
        if (uvm_top.get_report_verbosity_level() >= 200)
          uvm_top.print_topology();
      endfunction

      // ------------------CUSTOM VIRTUAL FUNCTIONS--------------------------

      // Custom function to start all sequences
      virtual task run_seqc();
        reset_seqc.start(env.reset_agt.sqr);
        repeat(1) begin
            seqc.start(env.rotate_agt.sqr);
        end
      endtask

      // Custom function to get sequence class through upcasting
      virtual function void get_seqc (inout base_seqc req);
            base_seqc seqc;

            seqc = base_seqc::type_id::create("seqc");
            req  = seqc;
      endfunction

      // Custom function to set delays between two transactions
      virtual function void set_cfg ();
            rotate_agent_cfg = rglib_rotate_agent_cfg::type_id::create("rotate_agent_cfg");
            rotate_agent_cfg.drv_delay_min = 0;
            rotate_agent_cfg.drv_delay_max = 0;
      endfunction
  endclass : base_test


//*******************************************************************************//
//                                  ROTATE TEST:                                 //
//                              Base test with 500 data                          //
//*******************************************************************************//
class rotate_test extends base_test;

    // ------------------Setup & local variables/objects------------------
    `uvm_component_utils(rotate_test);

    // Overload new() method in base_test
    function new(string name = "rotate_test", uvm_component parent = null);
        // new operation for base_test
        super.new(name, parent);
    endfunction

    // ------------------CUSTOM VIRTUAL FUNCTIONS--------------------------
    // Custom function to get sequence class through upcasting
    virtual function void get_seqc (inout base_seqc req);
        random_rotate_seqc seqc;

        seqc = random_rotate_seqc::type_id::create("seqc");
        req  = seqc;
    endfunction

    // Custom function to start all sequences
    virtual task run_seqc();
        reset_seqc.start(env.reset_agt.sqr);
        repeat(500) begin
            seqc.start(env.rotate_agt.sqr);
        end
    endtask

    // Custom function to set delays between two transactions
    virtual function void set_cfg ();
        rotate_agent_cfg = rglib_rotate_agent_cfg::type_id::create("rotate_agent_cfg");
        rotate_agent_cfg.drv_delay_min = 0;
        rotate_agent_cfg.drv_delay_max = 3;
    endfunction
endclass : rotate_test


//*******************************************************************************//
//                              SINGLE ROTATE TEST:                              //
//                          Base test with 500 data                              //
//*******************************************************************************//

class single_rotate_test extends base_test;

    // ------------------Setup & local variables/objects------------------
    `uvm_component_utils(single_rotate_test);

    // Overload new() method in base_test
    function new(string name = "rotate_test", uvm_component parent = null);
        // new operation for base_test
        super.new(name, parent);
    endfunction

    // ------------------CUSTOM VIRTUAL FUNCTIONS--------------------------
    // Custom function to get sequence class through upcasting
    virtual function void get_seqc (inout base_seqc req);
        single_rotate_seqc seqc;

        seqc = single_rotate_seqc::type_id::create("seqc");
        req  = seqc;
    endfunction

    // Custom function to start all sequences
    virtual task run_seqc();
        reset_seqc.start(env.reset_agt.sqr);
        repeat(3) begin
            seqc.start(env.rotate_agt.sqr);
        end
    endtask
endclass : single_rotate_test


//*******************************************************************************//
//                              MULTI RESET TEST :                               //
//                          10 times send reset & 20inputs                       //
//*******************************************************************************//

class multi_reset_test extends base_test;

    // ------------------Setup & local variables/objects------------------
    `uvm_component_utils(multi_reset_test);

    // Overload new() method of base_test
    function new(string name = "rotate_test", uvm_component parent = null);
        // new operation for base_test
        super.new(name, parent);
    endfunction

    // ------------------CUSTOM VIRTUAL FUNCTIONS--------------------------
    // Custom function to get sequence class through upcasting
    virtual function void get_seqc (inout base_seqc req);
        random_rotate_seqc seqc;

        seqc = random_rotate_seqc::type_id::create("seqc");
        req  = seqc;
    endfunction

    // Custom function to start all sequences
    virtual task run_seqc();
        repeat(10) begin
            reset_seqc.start(env.reset_agt.sqr);
            repeat(20) begin
                seqc.start(env.rotate_agt.sqr);
            end
        end
    endtask
endclass : multi_reset_test
