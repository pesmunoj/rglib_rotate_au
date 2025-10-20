
// Sequence item class.
// Randomized in sequence.
class reset_agent_seq_item_base extends uvm_sequence_item;

    `uvm_object_utils (reset_agent_seq_item_base);

    // Overload new() for seq_item
    function new(string name = "reset_agent_seq_item_base");
        super.new(name);
    endfunction

    // Duration in cycles of
    // reset signal while set to 1.
    int unsigned duration = 1;

    // Delay between two reset signals
    // in cycles.
    int unsigned delay;


endclass
