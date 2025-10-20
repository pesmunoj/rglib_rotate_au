
class rglib_rotate_agent extends uvm_agent;
    //***************************************************
    //        Setup & local variables/objects
    //***************************************************
    // Registration of class with the uvm factory
    `uvm_component_utils (rglib_rotate_agent);

    // Local objects of driver, sequencer and monitor classes
    virtual rglib_rotate_agent_if   agt_if;
    rglib_rotate_agent_cfg          cfg;
    rglib_rotate_agent_driver       drv;
    rglib_rotate_agent_sequencer    sqr;
    rglib_rotate_agent_monitor      mon;

    // Overloaded new method for uvm_agent class
    function new (string name = "rglib_rotate_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //***************************************************
    //                  BUILD_PHASE
    //***************************************************
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual rglib_rotate_agent_if)::get(this, "", "vif", agt_if))
          uvm_report_fatal(get_type_name(), "agent_interface not found");

        if(!uvm_config_db#(rglib_rotate_agent_cfg)::get(this, "", "cfg", cfg))
          uvm_report_fatal(get_type_name(), "agent_cfg not found");


        // Create driver and sequencer objects with uvm factory method
        drv  = rglib_rotate_agent_driver::type_id::create("drv", this);
        drv.drv_delay_min = cfg.drv_delay_min;
        drv.drv_delay_max = cfg.drv_delay_max;

        sqr = rglib_rotate_agent_sequencer::type_id::create("sqr", this);

        // Create monitor object with uvm factory method
        mon = rglib_rotate_agent_monitor::type_id::create("mon", this);
    endfunction

    //***************************************************
    //                  CONNECT_PHASE
    //***************************************************
    function void connect_phase (uvm_phase phase);
        // connect interface with drv & mon
        if(get_is_active == UVM_ACTIVE) begin
            // connect drv to sqr
            drv.seq_item_port.connect(sqr.seq_item_export);
            drv.driver_if =  agt_if;
        end
        mon.mon_if    =  agt_if;
    endfunction : connect_phase

endclass
