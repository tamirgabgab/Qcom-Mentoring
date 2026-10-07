//------------------------------------------------------------------------------
// clk_rst_rand_seq.sv -- sequence library of the Clock & Reset UVC
// Split out of clock_and_reset_seqs.sv: one class per file.
//------------------------------------------------------------------------------

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
