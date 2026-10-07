//------------------------------------------------------------------------------
// clock_and_reset_seqs.sv -- sequence library of the Clock & Reset UVC
//------------------------------------------------------------------------------

// Base sequence: raises an objection while it runs so the clock/reset item is
// always delivered, even if no other sequence is active yet.
class clock_and_reset_base_seq extends uvm_sequence #(clock_and_reset_transaction);

  `uvm_object_utils(clock_and_reset_base_seq)

  function new(string name = "clock_and_reset_base_seq");
    super.new(name);
  endfunction : new

  task pre_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.raise_objection(this, get_type_name());
  endtask : pre_body

  task post_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.drop_objection(this, get_type_name());
  endtask : post_body

endclass : clock_and_reset_base_seq


// clk10_rst5_seq: clock period 10, reset held for 5 cycles. The sequence every
// router test uses.
class clk10_rst5_seq extends clock_and_reset_base_seq;

  `uvm_object_utils(clk10_rst5_seq)

  function new(string name = "clk10_rst5_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing clk10_rst5_seq", UVM_LOW)
    `uvm_do_with(req, { req.clock_period == 10; req.reset_cycles == 5; })
  endtask : body

endclass : clk10_rst5_seq


// clk_rst_rand_seq: random period and reset length (useful for robustness runs)
class clk_rst_rand_seq extends clock_and_reset_base_seq;

  `uvm_object_utils(clk_rst_rand_seq)

  function new(string name = "clk_rst_rand_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing clk_rst_rand_seq", UVM_LOW)
    `uvm_do(req)
  endtask : body

endclass : clk_rst_rand_seq
