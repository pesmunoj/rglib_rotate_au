class rglib_rotate_agent_cfg extends uvm_object;

  `uvm_object_utils(rglib_rotate_agent_cfg)

  int   drv_delay_min;
  int   drv_delay_max;

  // Overload new() for seq_item
  function new(string name = "rglib_rotate_agent_cfg");
      super.new(name);
  endfunction

endclass
