//------------------------------------------------------------------------------
// clk_rst_rand_seq.sv -- sequence library of the Clock & Reset UVC
// Split out of clock_and_reset_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// clk_rst_rand_seq: random period and reset length (useful for robustness runs)
class clk_rst_rand_seq extends clock_and_reset_base_seq;

  `uvm_object_utils(clk_rst_rand_seq)

  extern function new(string name = "clk_rst_rand_seq");
  extern task body();

endclass : clk_rst_rand_seq

//------------------------------------------------------------------------------
// clk_rst_rand_seq -- method implementations
//------------------------------------------------------------------------------

function clk_rst_rand_seq::new(string name = "clk_rst_rand_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task clk_rst_rand_seq::body();
  `uvm_info(get_type_name(), "Executing clk_rst_rand_seq", UVM_LOW)
  req = clock_and_reset_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize()) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
endtask : body
