
// Reset signal agent.
// Has sequencer, driver. No monitor
class reset_agent_base extends uvm_agent;
    // Registration of class with the uvm factory
    `uvm_component_utils (reset_agent_base);

    // Component handle.
    virtual reset_if           vif;
    reset_agent_sequencer_base sqr;
    reset_agent_driver_base    drv;
    reset_agent_monitor_base   mon;

    // Overload new() method for uvm_agent class
    function new(string name = "reset_agent_base", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Overload build phase.
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual reset_if)::get(this, "", "vif", vif))
              uvm_report_fatal(get_type_name(), "agent_interface not found");

        sqr = reset_agent_sequencer_base::type_id::create("sqr", this);
        drv = reset_agent_driver_base   ::type_id::create("drv", this);
        mon = reset_agent_monitor_base  ::type_id::create("mon", this);
    endfunction

    // Метод соединения.
    function void connect_phase (uvm_phase phase);
      // connect interface & seqr with drv
      drv.seq_item_port.connect(sqr.seq_item_export);
      drv.vif =  vif;
      mon.vif =  vif;
    endfunction : connect_phase

endclass
