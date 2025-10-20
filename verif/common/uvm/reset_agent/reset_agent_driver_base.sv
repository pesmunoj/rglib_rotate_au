
class reset_agent_driver_base extends uvm_driver#(reset_agent_seq_item_base);
    `uvm_component_utils (reset_agent_driver_base)
    // Reset intf handle.
    virtual reset_if vif;

    // Override new()
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    // Run phase. Sets ~reset~ to 1
    // for ~duration~ cycles with ~delay~
    // before dropping ~reset to 0
    virtual task run_phase (uvm_phase phase);
      forever begin
        seq_item_port.get_next_item(req);
        repeat(req.delay) begin
          @(posedge vif.clk);
        end
        @(negedge vif.clk);
        vif.reset <= 1'b1;
        repeat(req.duration) begin
          @(posedge vif.clk);
        end
        @(negedge vif.clk);
        vif.reset = 1'b0;
        seq_item_port.item_done(req);
      end
    endtask

endclass
