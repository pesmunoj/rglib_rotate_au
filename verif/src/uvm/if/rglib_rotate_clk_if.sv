`timescale 1ns/1ns

interface rglib_rotate_clk_if;

  //-------------------------------------------------
  // Parameters
  //-------------------------------------------------

  // Clock period
  real clk_period = 10;

  // Clock phase
  real clk_phase = 0;

  // Clock initial value
  bit clk_init = 0;

  // Clock generation event
  bit clk_gen;

  logic clk;


  //-------------------------------------------------
  // API
  //-------------------------------------------------

  // Set all clock parameters
  function void set_clk(real period, bit init);
    set_clk_period(period);
    set_clk_init(init);
  endfunction

  // Set clock period
  function void set_clk_period(real period);
    clk_period = period;
  endfunction

  // Set clock phase
  function void set_clk_phase(real phase);
    clk_phase = phase;
  endfunction

  // Set clock initial value
  function void set_clk_init(bit init);
    clk_init = init;
  endfunction

  // Start clock generation
  task start_clk(bit do_phase = 0);
    if(do_phase) #(clk_phase);
    clk_gen = 1;
  endtask

  // Stop clock generation
  function void stop_clk();
    clk_gen = 0;
  endfunction

  // Clock tick task
  task automatic tick(input bit level = 1);
    if(level) @(posedge clk);
    else @(negedge clk);
  endtask


  // Clock synchronization function
  task automatic sync_clk(ref logic in, input bit level);
    stop_clk();
    if(level) @(posedge in);
    else @(negedge in);
    clk = clk_init;
    start_clk();
  endtask


  //-------------------------------------------------
  // Clock generation
  //-------------------------------------------------

  initial begin
    // Wait for clock generation permission
    wait(clk_gen);
    // Generate clock
    clk <= clk_init;
    fork
      forever begin
        wait(clk_gen);
        #(clk_period/2) clk <= ~clk;
      end
    join_none
  end

endinterface : rglib_rotate_clk_if
