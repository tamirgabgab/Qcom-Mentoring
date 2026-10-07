//------------------------------------------------------------------------------
// clk10_rst5_seq.sv -- sequence library of the Clock & Reset UVC
// Split out of clock_and_reset_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// clk10_rst5_seq: clock period 10, reset held for 5 cycles. The sequence every
// router test uses.
class clk10_rst5_seq extends clock_and_reset_base_seq;

  `uvm_object_utils(clk10_rst5_seq)

  extern function new(string name = "clk10_rst5_seq");
  extern task body();

endclass : clk10_rst5_seq

//------------------------------------------------------------------------------
// clk10_rst5_seq -- method implementations
//------------------------------------------------------------------------------

function clk10_rst5_seq::new(string name = "clk10_rst5_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task clk10_rst5_seq::body();
  `uvm_info(get_type_name(), "Executing clk10_rst5_seq", UVM_LOW)
  req = clock_and_reset_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.clock_period == 10; req.reset_cycles == 5; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
endtask : body
