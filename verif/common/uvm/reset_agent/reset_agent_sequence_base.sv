
// Sequence to generate ~reset_seq_item~ transactions.
class reset_agent_sequence_base extends
    uvm_sequence#(reset_agent_seq_item_base);

    // Registration of class with the uvm factory
    `uvm_object_utils (reset_agent_sequence_base);

    // Local seq_item object
    reset_agent_seq_item_base req;

    // Reset duration
    int duration = 1;

    // ~body()~ generates data.
    // Transaction is created between
    // ~start_item(data)~ and ~finish_item(data)~.

    // Overloading of new method for uvm_sequence
    function new (string name = "reset_agent_sequence_base");
      super.new(name);
    endfunction

    virtual task body();
        req = reset_agent_seq_item_base :: type_id :: create();

        start_item(req);
        req.duration = duration; //$urandom_range(3,5);
        req.delay    = 0;
        finish_item(req);
    endtask

endclass
