module rglib_rotate_coverage_sva#() (
    input clk,
    input reset,
    input in_valid,
    input out_valid
);
    //***************************************************
    //      Disable next coverage functions/properties
    //      in case +define+COVERAGE_EN
    //      is not set in built script
    //***************************************************
    `ifdef COVERAGE_EN

        //***************************************************
        //                  Properties
        //***************************************************

        property input_while_reset_p;
            reset & in_valid;
        endproperty

        property output_while_reset_p;
            reset & out_valid;
        endproperty

        property no_data_while_reset_p;
            reset & ~(in_valid|out_valid);
        endproperty

        //***************************************************
        //                  Cover
        //***************************************************
        input_while_reset_c   : cover property( @(posedge clk) disable iff (~reset) input_while_reset_p);
        output_while_reset_c  : cover property( @(posedge clk) disable iff (~reset) output_while_reset_p);
        no_data_while_reset_c : cover property( @(posedge clk) disable iff (~reset) no_data_while_reset_p);
    `endif
endmodule : rglib_rotate_coverage_sva
