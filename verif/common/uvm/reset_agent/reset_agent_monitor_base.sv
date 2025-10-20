
class reset_agent_monitor_base extends uvm_monitor;

    //***************************************************
    //         Setup & local variables/objects
    //***************************************************

    // Class monitor registration in uvm
    `uvm_component_utils( reset_agent_monitor_base )

    // Interface handle
    virtual reset_if  vif;
    // Create port that broadcasts a value to all subscribers
    uvm_analysis_port #(bit) item_collect_port;

    // Overloading of new method for uvm_monitor
    function new(string name = "reset_agent_monitor_base", uvm_component parent = null);
        super.new(name, parent);
        // Create port & temp item
        item_collect_port  = new("item_collect_port", this);
    endfunction : new

    //***************************************************
    //                  BUILD_PHASE
    //***************************************************
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    //***************************************************
    //                  RUN_PHASE
    //***************************************************
    task run_phase (uvm_phase phase);
        uvm_report_info(get_type_name(),"Run phase start", UVM_LOW);
        forever begin
            monitor_reset();
        end
    endtask

    task monitor_reset;
        // Checking for reset on reset_intf
        @ ( posedge vif.clk iff vif.reset ) begin
            uvm_report_info(get_type_name(),"Detected reset!", UVM_HIGH);
            item_collect_port.write(1);
            @(negedge vif.reset);
        end
    endtask

endclass
