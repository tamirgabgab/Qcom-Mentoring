//------------------------------------------------------------------------------
// router_hbus_bits_coverage.sv -- every bit of the read-write registers written
// as 0 and as 1 (test plan COV-05)
//
//   hbus monitor ──► router_module_env.hbus_export ──► analysis_export (write)
//
// One sample per bit of every HBUS write to ctrl_reg (0x1000) or en_reg
// (0x1001): which register, which bit, which value. The reserved bits
// (ctrl_reg[7:6], en_reg[3]) are read-write too, so they count.
//------------------------------------------------------------------------------
class router_hbus_bits_coverage extends uvm_subscriber #(hbus_transaction);

  int num_writes;

  covergroup hbus_bits_cg with function sample(bit is_en, int bit_index, bit value);
    option.per_instance = 1;
    reg_cp : coverpoint is_en {
      bins ctrl_reg = {0};
      bins en_reg   = {1};
    }
    bit_cp : coverpoint bit_index {
      bins b[] = {[0:7]};
    }
    val_cp : coverpoint value {
      bins zero = {0};
      bins one  = {1};
    }
    reg_x_bit_x_val : cross reg_cp, bit_cp, val_cp;
  endgroup : hbus_bits_cg

  `uvm_component_utils(router_hbus_bits_coverage)

  extern function new(string name, uvm_component parent);

  // One HBUS access from the monitor; only writes to ctrl_reg / en_reg count
  extern function void write(hbus_transaction t);

  extern function void report_phase(uvm_phase phase);

endclass : router_hbus_bits_coverage

//------------------------------------------------------------------------------
// router_hbus_bits_coverage -- method implementations
//------------------------------------------------------------------------------

function router_hbus_bits_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  hbus_bits_cg = new();
endfunction : new

//------------------------------------------------------------------------------
function void router_hbus_bits_coverage::write(hbus_transaction t);
  if (t.hwr_rd != HBUS_WRITE || !(t.haddr inside {16'h1000, 16'h1001})) begin
    return;
  end
  num_writes++;
  for (int i = 0; i < 8; i++) begin
    hbus_bits_cg.sample(t.haddr == 16'h1001, i, t.hdata[i]);
  end
endfunction : write

//------------------------------------------------------------------------------
function void router_hbus_bits_coverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("HBUS register bits coverage: %0d writes to ctrl_reg/en_reg, coverage %.1f%%",
                                       num_writes, hbus_bits_cg.get_inst_coverage()), UVM_LOW)
endfunction : report_phase
