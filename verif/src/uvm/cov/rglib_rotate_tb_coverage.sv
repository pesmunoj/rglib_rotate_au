
	class rglib_rotate_tb_coverage extends uvm_subscriber #(rglib_rotate_agent_seq_item);
		//***************************************************
        //                  Setup
        //***************************************************
		// The utils macro is used primarily to register an object or component with the factory
		// and is required for it to function correctly.
		`uvm_component_utils(rglib_rotate_tb_coverage)

		// Local seq_item object
		rglib_rotate_agent_seq_item item;

		//***************************************************
        //           overload new() and write()
        //***************************************************
		function new (string name = "rglib_rotate_tb_coverage", uvm_component parent);
			super.new(name, parent);
			// seq_item_cg = new();
		endfunction : new

		// overload the write method
		virtual function void write (rglib_rotate_agent_seq_item t);
			item = t;
			// `uvm_info(get_type_name, $sformatf("New transaction received.c_init = %0d", item.c_init), UVM_LOW);
			// seq_item_cg.sample();
			// `uvm_info(get_type_name, $sformatf("Current coverage = %0.4f %%", seq_item_cg.get_coverage()), UVM_LOW);
		endfunction : write

	endclass : rglib_rotate_tb_coverage
