//------------------------------------------------------------------------------
// clk10_rst5_seq.sv -- sequence library of the Clock & Reset UVC
// Split out of clock_and_reset_seqs.sv: one class per file.
//------------------------------------------------------------------------------

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
