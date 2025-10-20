
class rglib_rotate_agent_seq_item extends uvm_sequence_item;

  rotate_data_t   data;
  rotate_val_t    rotate_val;

  // Overload new() for seq_item
  function new(string name = "rglib_rotate_agent_seq_item");
      super.new(name);
  endfunction

  virtual function void report_item (uvm_verbosity verbosity);
    uvm_report_info ( get_type_name,
                      $sformatf ({"Item data: %d \n",
                                  "Item rotate_val: %d"},
                                  data,
                                  rotate_val),
                      verbosity );
  endfunction

  // UVM Factory macros
  `uvm_object_utils_begin(rglib_rotate_agent_seq_item)
      `uvm_field_int(data, UVM_ALL_ON)
      `uvm_field_int(rotate_val, UVM_ALL_ON)
  `uvm_object_utils_end

endclass
