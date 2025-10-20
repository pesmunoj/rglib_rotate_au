import rglib_rotate_params_pkg::*;
class rglib_rotate_tb_coverage_cg extends uvm_component ;

    //-----------------------Setup-------------------------
    // The utils macro is used primarily to register an object or component with the factory
    // and is required for it to function correctly.
    `uvm_component_utils(rglib_rotate_tb_coverage_cg)

    // Receives all transactions broadcasted by a uvm_analysis_port.
    // It serves as the termination point of an analysis port/export/imp connection.
    // The component attached to the imp class--called a subscriber-- implements the analysis interface.
    uvm_analysis_imp_in  #(rglib_rotate_agent_seq_item, rglib_rotate_tb_coverage_cg) item_collect_port_in;
    uvm_analysis_imp_out #(rglib_rotate_agent_seq_item, rglib_rotate_tb_coverage_cg) item_collect_port_out;

    //***************************************************
    //      Disable next coverage functions/properties
    //      in case +define+COVERAGE_EN
    //      is not set in built script
    //***************************************************
    `ifdef COVERAGE_EN
    //***************************************************
        //                  Covergroups
        //***************************************************
        covergroup config_cg;

            rglib_rotate_out_reg_cp:
                coverpoint RGLIB_ROTATE_OUT_REG{
                    bins false = {"FALSE"};
                    bins true  = {"TRUE"};
                }

            rglib_rotate_rotate_direction_cp:
                coverpoint RGLIB_ROTATE_ROTATE_DIRECTION{
                    bins left  = {"LEFT"};
                    bins right = {"RIGHT"};
                }

            rglib_rotate_data_width_cp:
                coverpoint RGLIB_ROTATE_DATA_WIDTH{
                    bins values [] = {[1:128]};
                }

            rglib_rotate_pow_granularity_cp:
                coverpoint RGLIB_ROTATE_POW_GRANULARITY{
                    bins values [] = {[0:7]};
                }

            rglib_rotate_rotate_stage_num_cp:
                coverpoint RGLIB_ROTATE_ROTATE_STAGE_NUM{
                    bins values [] = {[0:7]};
                }

        endgroup

        covergroup data_cg with function sample (rglib_rotate_agent_seq_item input_item);

            corner_out_data_cp:
                coverpoint input_item.data;

            rotate_val:
                coverpoint input_item.rotate_val{
                    bins values [8] = { [0:8] };
                }

        endgroup

        //***************************************************
        //                  write_*()
        //***************************************************

        // Save config data before check.
        virtual function void write_reset( bit reset_f );

		endfunction : write_reset

        // Sample in data.
        virtual function void write_in( input rglib_rotate_agent_seq_item seq_item );

			rglib_rotate_agent_seq_item 	data_item;

            // Try to copy item to local, else throw fatal
            if(!$cast(data_item, seq_item.clone()))
                uvm_report_fatal({get_type_name," write_in"},
                    {$sformatf("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"),
                    $sformatf("\n\tILLEGAL $cast()"),
                    $sformatf("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")});

			data_cg.sample(data_item);
        endfunction : write_in

        // Sample out data.
        virtual function void write_out( input rglib_rotate_agent_seq_item seq_item );

			rglib_rotate_agent_seq_item 	data_item;

            // Try to copy item to local, else throw fatal
            if(!$cast(data_item, seq_item.clone()))
                uvm_report_fatal({get_type_name," write_out"},
                    {$sformatf("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"),
                    $sformatf("\n\tILLEGAL $cast()"),
                    $sformatf("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")});

            data_cg.sample(data_item);
        endfunction : write_out
    `else
    //------- hollow write_* functions---------
        // Sample in data.
        virtual function void write_in( input rglib_rotate_agent_seq_item seq_item );
        endfunction : write_in

        // Sample out data.
        virtual function void write_out( input rglib_rotate_agent_seq_item seq_item );
        endfunction : write_out
    `endif

    //***************************************************
    //                  NEW()
    //***************************************************
     function new (string name = "rglib_rotate_tb_coverage_cg", uvm_component parent);
        super.new(name, parent);
        `ifdef COVERAGE_EN
            config_cg = new();
            config_cg.sample();
            data_cg   = new();
        `endif
    endfunction : new

    //***************************************************
    //                  BUILD_PHASE
    //***************************************************
    virtual function void build_phase( uvm_phase phase );
        super.build_phase(phase);
        item_collect_port_in  = new("item_collect_port_in", this);
        item_collect_port_out = new("item_collect_port_out", this);
    endfunction

endclass : rglib_rotate_tb_coverage_cg
