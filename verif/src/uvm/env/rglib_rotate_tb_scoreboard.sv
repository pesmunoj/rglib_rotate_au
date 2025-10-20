
  class rglib_rotate_tb_scoreboard extends uvm_scoreboard;
      //***************************************************
      //        Setup & local variables/objects
      //***************************************************
      // Register scoreboard class in uvm
      `uvm_component_utils (rglib_rotate_tb_scoreboard);

      logic rotate_dir_f;

      // Receives all transactions broadcasted by a uvm_analysis_port.
      // It serves as the termination point of an analysis port/export/imp connection.
      // The component attached to the imp class--called a subscriber-- implements the analysis interface.
      uvm_analysis_imp_in  #(rglib_rotate_agent_seq_item, rglib_rotate_tb_scoreboard) item_collect_port_in;
      uvm_analysis_imp_out #(rglib_rotate_agent_seq_item, rglib_rotate_tb_scoreboard) item_collect_port_out;

      // Queue of seq_items
      rglib_rotate_agent_seq_item input_item_q[$];
      rglib_rotate_agent_seq_item output_item_q[$];

      // item counters
      int   checked_item_cnt;
      int   in_item_cnt     ;
      int   out_item_cnt    ;

      int   fail_item_cnt   ;
      int   fail_item_num[$];

      rotate_data_t  fail_data_in_q [$];
      rotate_data_t  fail_data_out_q[$];
      rotate_val_t   fail_rv_q      [$];

      // item flags
      logic in_item_f;
      logic out_item_f;
      logic item_error_f;


      //***************************************************
      //                  write() + overload new()
      //***************************************************
      function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
        item_collect_port_in  = new("item_collect_port_in", this);
        item_collect_port_out = new("item_collect_port_out", this);

        in_item_cnt   = 0;
        out_item_cnt  = 0;

        fail_item_cnt = 0;
        item_error_f  = 0;

        in_item_f     = 0;
        out_item_f    = 0;
      endfunction

      // add seq_item into queue
      function void write_in  (rglib_rotate_agent_seq_item seq_item);

        rglib_rotate_agent_seq_item temp_item;

        $cast(temp_item,seq_item.clone());
        input_item_q.push_back(temp_item);

        in_item_f    = 1;
        in_item_cnt += 1;
      endfunction

      function void write_out (rglib_rotate_agent_seq_item seq_item);
        rglib_rotate_agent_seq_item temp_item;

        $cast(temp_item,seq_item.clone());
        output_item_q.push_back(temp_item);

        out_item_f    = 1;
        out_item_cnt += 1;

        check_transaction();
      endfunction

      //***************************************************
      //                  BUILD_PHASE
      //***************************************************
      function void build_phase (uvm_phase phase);
          super.build_phase(phase);

          if (RGLIB_ROTATE_ROTATE_DIRECTION == "LEFT") rotate_dir_f = 0;
          else if (RGLIB_ROTATE_ROTATE_DIRECTION == "RIGHT") rotate_dir_f = 1;
            else $fatal("Unknown RGLIB_ROTATE_ROTATE_DIRECTION parameter value");
      endfunction

      //***************************************************
      //               CHECK TRANSACTION ()
      //***************************************************
      function void check_transaction ();

        // Local seq_items
        rglib_rotate_agent_seq_item  input_seqi;
        rglib_rotate_agent_seq_item  output_seqi;

        // Get seq_item from queue
        input_seqi  = input_item_q.pop_front();
        output_seqi = output_item_q.pop_front();

        uvm_report_info(get_type_name,"New transaction to check", UVM_HIGH);

        // if out_item is without in_item
        // add error
        if (out_item_f != in_item_f) begin
          uvm_report_info(get_type_name,
                          $sformatf("No input item"),
                          UVM_LOW);
          item_error_f = 1;
          fail_item_num.push_back(in_item_cnt);
          fail_data_in_q.push_back( input_seqi .data);
          fail_data_out_q.push_back ( output_seqi.data);
          fail_rv_q.push_back ( input_seqi .rotate_val);
        end

        // if out rotate value is faulty
        // add error
        if (output_seqi.rotate_val != input_seqi.rotate_val) begin
          uvm_report_info(get_type_name,
                          $sformatf("Wrong rotate_val"),
                          UVM_LOW);
          item_error_f = 1;
          fail_item_num.push_back(in_item_cnt);
          fail_data_in_q.push_back (input_seqi .data);
          fail_data_out_q.push_back ( output_seqi.data);
          fail_rv_q.push_back ( input_seqi .rotate_val);
        end

        // if data is faulty
        // add error
        if (golden_model(input_seqi.data, input_seqi.rotate_val) != output_seqi.data) begin
          uvm_report_info(get_type_name,
                $sformatf("Wrong data"),
                UVM_LOW);
          item_error_f = 1;
          fail_item_num.push_back(in_item_cnt);
          fail_data_in_q.push_back( input_seqi .data);
          fail_data_out_q.push_back ( output_seqi.data);
          fail_rv_q.push_back ( input_seqi .rotate_val);
        end

        checked_item_cnt +=1;
        in_item_f  = 0;
        out_item_f = 0;

        item_report();
      endfunction

      //***************************************************
      //                  ITEM_REPORT ()
      //***************************************************
      function void item_report ();
        // Item report
        fail_item_cnt += ( item_error_f != 0 );

        if (item_error_f == 1)  begin
          uvm_report_error(get_type_name,
                          $sformatf("\n\t!!! FAILED GLORIOUSLY !!!\n\t input items: %d \n\t output items: %d",
                                    in_item_cnt, out_item_cnt));
          uvm_report_info(get_type_name,
                          $sformatf("\ninput data: %b, golden_data: %b \n output data: %b",
                                    fail_data_in_q[$], golden_model( fail_data_in_q[$], fail_rv_q[$]), fail_data_out_q[$]),
                          UVM_LOW);
        end


        item_error_f = 0;
      endfunction

      //***************************************************
      //                  REPORT_PHASE
      //***************************************************
      function void report_phase(uvm_phase phase);
          super.report_phase(phase);

          $display("/---------------------------------------------------------------------------------------------------------------/");
          $display("/--------------------------------FINAL--------------------------------REPORT------------------------------------/");
          $display("/---------------------------------------------------------------------------------------------------------------/");
          uvm_report_info(get_type_name,
                          $sformatf("\n\tNumber of tested transactions %0d, number of failed transations: %0d",
                          checked_item_cnt, fail_item_cnt),
                          UVM_LOW);

          if ( (fail_item_cnt  == 0) && ( checked_item_cnt != 0 ))
            uvm_report_info(get_type_name,
                            $sformatf("\n\t!!! ALL PASSED !!!" ),
                            UVM_LOW);
          else
          if ( in_item_cnt == 0 )
            uvm_report_error(get_type_name,
                             $sformatf("\n\t!!! NO INPUT_ITEMS DETECTED !!!" ),
                             UVM_LOW);
          else
          if ( out_item_cnt == 0 )
            uvm_report_error(get_type_name,
                             $sformatf("\n\t!!! NO OUTPUT_ITEMS DETECTED !!!" ),
                             UVM_LOW);
          else begin

              uvm_report_error(get_type_name,
                              $sformatf("\n\t!!! NOT PASSED !!!" ),
                              UVM_LOW);
              uvm_report_info(get_type_name,
                              $sformatf("\n\tFailed transaction numbers:" ),
                              UVM_MEDIUM);
            // display failed nums if uvm verbosity >= UVM_MEDIUM
            if (uvm_top.get_report_verbosity_level() >= 200) begin
                for (int i = 0; i < fail_item_num.size; i++) begin
                    $display($sformatf("num:%0d--in:%0d--out:%0d",fail_item_num[i], fail_data_in_q[i],fail_data_out_q[i]));
                end
            end
          end
          $display("/---------------------------------------------------------------------------------------------------------------/");
          $display("/--------------------------------FINAL--------------------------------REPORT------------------------------------/");
          $display("/---------------------------------------------------------------------------------------------------------------/");

      endfunction

      function rotate_data_t golden_model(input rotate_data_t data, input rotate_val_t rotate_val);
          if (rotate_dir_f == 0)
            data = (data << rotate_val*RGLIB_ROTATE_POW_GRANULARITY) | (data >> (RGLIB_ROTATE_DATA_WIDTH - rotate_val*RGLIB_ROTATE_POW_GRANULARITY));
          else
            data = (data << (RGLIB_ROTATE_DATA_WIDTH - rotate_val*RGLIB_ROTATE_POW_GRANULARITY)) | (data >> rotate_val*RGLIB_ROTATE_POW_GRANULARITY);
        return data;
      endfunction
  endclass
