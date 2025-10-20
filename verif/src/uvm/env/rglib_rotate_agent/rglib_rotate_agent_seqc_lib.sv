class base_seqc extends uvm_sequence #(rglib_rotate_agent_seq_item);
    //***************************************************
    //        Setup & local variables/objects
    //***************************************************

    // Registration of class with the uvm factory
    `uvm_object_utils (base_seqc);

    // Local req object
    rglib_rotate_agent_seq_item req;

    // Overloading of new method for uvm_sequence
    function new (string name = "base_seqc");
        super.new(name);
    endfunction

    // Custom function to set data in sequence_item
    virtual function void set_item (inout rglib_rotate_agent_seq_item req);
        req.data        = 'x;
        req.rotate_val  = 'x;
    endfunction

    //***************************************************
    //              Item send
    //***************************************************
    // overloading of the user-defined task where the main sequence code resides.
    // This method should not be called directly by the user.
    task body();
        req    = rglib_rotate_agent_seq_item :: type_id :: create();

        // Ask to send to driver
        start_item(req);
        set_item(req);
        req.report_item(UVM_DEBUG);
        finish_item(req);
    endtask // End body()
endclass

class random_rotate_seqc extends base_seqc;
  // Registration of class with the uvm factory
  `uvm_object_utils (random_rotate_seqc);

  // Overloading of new method for uvm_sequence
  function new (string name = "random_rotate_seqc");
      super.new(name);
  endfunction

  // Custom function to set data in sequence_item
  virtual function void set_item (inout rglib_rotate_agent_seq_item req);
      req.data        = $urandom();
      req.rotate_val  = $urandom();
  endfunction
endclass

class single_rotate_seqc extends base_seqc;
    // Registration of class with the uvm factory
    `uvm_object_utils (single_rotate_seqc);

    // Overloading of new method for uvm_sequence
    function new (string name = "single_rotate_seqc");
        super.new(name);
    endfunction

    // Custom function to set data in sequence_item
    virtual function void set_item (inout rglib_rotate_agent_seq_item req);
      req.data       = 32'hbaba_deda;
      req.rotate_val = 16;
    endfunction
endclass
