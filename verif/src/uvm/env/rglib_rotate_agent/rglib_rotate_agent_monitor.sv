
class rglib_rotate_agent_monitor extends uvm_monitor;

    //***************************************************
    //         Setup & local variables/objects
    //***************************************************

    // Class monitor registration in uvm
    `uvm_component_utils( rglib_rotate_agent_monitor )

    virtual rglib_rotate_agent_if  mon_if;

    // DUT parameter flag
    bit out_reg_f;

    // If out_reg_f == 1, will keep previous rotate_val
    rotate_data_t prev_rotate_val;

    // Create port that broadcasts a value to all subscribers
    uvm_analysis_port #(rglib_rotate_agent_seq_item) item_collect_port_in;
    uvm_analysis_port #(rglib_rotate_agent_seq_item) item_collect_port_out;

    // Local seq_item object
    rglib_rotate_agent_seq_item mon_in_item;
    rglib_rotate_agent_seq_item mon_out_item;

    // Overloading of new method for uvm_monitor
    function new(string name = "rglib_rotate_agent_monitor", uvm_component parent = null);
        super.new(name, parent);
        // Allocate memory for port & temp item
        item_collect_port_in  = new("item_collect_port_in", this);
        item_collect_port_out = new("item_collect_port_out", this);
    endfunction : new

    //***************************************************
    //                  BUILD_PHASE
    //***************************************************
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (RGLIB_ROTATE_OUT_REG == "FALSE") out_reg_f = 0;
        else if (RGLIB_ROTATE_OUT_REG == "TRUE") out_reg_f = 1;
          else $fatal(1, "Unknown RGLIB_ROTATE_OUT_REG parameter value");

    endfunction

    //***************************************************
    //                  RUN_PHASE
    //***************************************************
    task run_phase (uvm_phase phase);
      uvm_report_info(get_type_name(),"Run phase start", UVM_LOW);
      forever begin
        @(posedge mon_if.clk) begin
            input_monitor();
            if(out_reg_f) @(posedge mon_if.clk);
            output_monitor();
        end
      end
    endtask

    task input_monitor;
      // Checking for input
      if (mon_if.in_valid === 1'b1) begin
        mon_in_item  = rglib_rotate_agent_seq_item :: type_id :: create("mon_in_item", this);
        mon_in_item.data       = mon_if.in;
        mon_in_item.rotate_val = mon_if.rotate_val;
        uvm_report_info(get_type_name(),"Sending input transaction", UVM_HIGH);
        item_collect_port_in.write(mon_in_item);
        prev_rotate_val <= mon_in_item.rotate_val;
      end

    endtask

    task output_monitor;
      // Checking for output
      if (mon_if.out_valid === 1'b1) begin
        mon_out_item = rglib_rotate_agent_seq_item :: type_id :: create("mon_out_item", this);
        mon_out_item.data       = mon_if.out;
        if (out_reg_f == 1)
          mon_out_item.rotate_val = prev_rotate_val;
        if (out_reg_f == 0)
          mon_out_item.rotate_val = mon_if.rotate_val;
        uvm_report_info(get_type_name(),"Sending output transaction", UVM_HIGH);
        item_collect_port_out.write(mon_out_item);
      end
    endtask

endclass
