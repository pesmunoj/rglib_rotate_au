
class rglib_rotate_agent_driver extends uvm_driver #(rglib_rotate_agent_seq_item);

    //***************************************************
    //         Setup & local variables/objects
    //***************************************************
    // Registration of driver class
    `uvm_component_utils (rglib_rotate_agent_driver)

    // instance of if_base class;
    virtual rglib_rotate_agent_if     driver_if;
    rglib_rotate_agent_seq_item       seq_item;

    // Delay between transactions, set in test.
    // Default is 0
    int drv_delay_min;
    int drv_delay_max;

    // Overloaded new method for uvm_driver class
    function new(string name = "rglib_rotate_agent_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction
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
      // forever loop
      forever begin

        // Delay between transactions
        repeat ($urandom_range(drv_delay_min, drv_delay_max))
          @(posedge driver_if.clk);

        seq_item_port.try_next_item(seq_item);
        if (seq_item != null) begin
          if (driver_if.kill === 1'b0) begin
            driver_if.in_valid   <= 1'b1;
            driver_if.rotate_val <= seq_item.rotate_val;
            driver_if.in         <= seq_item.data;
          end else if (driver_if.kill === 1'b1) begin
            driver_if.in_valid   <= 1'b0;
            driver_if.rotate_val <= $urandom();
            driver_if.in         <= $urandom();
          end
          seq_item_port.item_done();
        end
        @(posedge driver_if.clk);
        driver_if.in_valid <= 1'b0;
        seq_item  = null;
      end //forever
    endtask
endclass
