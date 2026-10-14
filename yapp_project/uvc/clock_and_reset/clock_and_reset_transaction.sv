//------------------------------------------------------------------------------
// clock_and_reset_transaction.sv -- one "start the clock and pulse reset" item
//------------------------------------------------------------------------------
class clock_and_reset_transaction extends uvm_sequence_item;

  rand int m_clock_period;   // time units per clock cycle
  rand int m_reset_cycles;   // clock cycles reset is held high

  `uvm_object_utils(clock_and_reset_transaction)

  extern constraint c_period;
  extern constraint c_reset;

  // Printing, copying, comparing, packing and recording are written by hand
  // (do_print / do_copy / do_compare / do_pack / do_unpack / do_record below):
  // no uvm_field_* automation.
  extern virtual function void do_copy(uvm_object rhs);
  extern virtual function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern virtual function void do_print(uvm_printer printer);
  extern virtual function void do_pack(uvm_packer packer);
  extern virtual function void do_unpack(uvm_packer packer);
  extern virtual function void do_record(uvm_recorder recorder);
  extern function new(string name = "clock_and_reset_transaction");

endclass : clock_and_reset_transaction

//------------------------------------------------------------------------------
// clock_and_reset_transaction -- constraints
//------------------------------------------------------------------------------

constraint clock_and_reset_transaction::c_period {
  m_clock_period inside {[2:100]};
  m_clock_period % 2 == 0;
}

//------------------------------------------------------------------------------
constraint clock_and_reset_transaction::c_reset {
  m_reset_cycles inside {[1:20]};
}

//------------------------------------------------------------------------------
// clock_and_reset_transaction -- method implementations
//------------------------------------------------------------------------------

function clock_and_reset_transaction::new(string name = "clock_and_reset_transaction");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
function void clock_and_reset_transaction::do_copy(uvm_object rhs);
  clock_and_reset_transaction rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "do_copy: rhs is not a clock_and_reset_transaction")
  end
  super.do_copy(rhs);
  m_clock_period = rhs_.m_clock_period;
  m_reset_cycles = rhs_.m_reset_cycles;
endfunction : do_copy

//------------------------------------------------------------------------------
function bit clock_and_reset_transaction::do_compare(uvm_object rhs, uvm_comparer comparer);
  clock_and_reset_transaction rhs_;
  if (!$cast(rhs_, rhs)) begin
    return 0;
  end
  do_compare = super.do_compare(rhs, comparer);
  do_compare &= comparer.compare_field_int("clock_period", m_clock_period, rhs_.m_clock_period, $bits(m_clock_period), UVM_DEC);
  do_compare &= comparer.compare_field_int("reset_cycles", m_reset_cycles, rhs_.m_reset_cycles, $bits(m_reset_cycles), UVM_DEC);
endfunction : do_compare

//------------------------------------------------------------------------------
function void clock_and_reset_transaction::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("clock_period", m_clock_period, $bits(m_clock_period), UVM_DEC);
  printer.print_field("reset_cycles", m_reset_cycles, $bits(m_reset_cycles), UVM_DEC);
endfunction : do_print

//------------------------------------------------------------------------------
function void clock_and_reset_transaction::do_pack(uvm_packer packer);
  super.do_pack(packer);
  packer.pack_field_int(m_clock_period, $bits(m_clock_period));
  packer.pack_field_int(m_reset_cycles, $bits(m_reset_cycles));
endfunction : do_pack

//------------------------------------------------------------------------------
function void clock_and_reset_transaction::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  m_clock_period = packer.unpack_field_int($bits(m_clock_period));
  m_reset_cycles = packer.unpack_field_int($bits(m_reset_cycles));
endfunction : do_unpack

//------------------------------------------------------------------------------
function void clock_and_reset_transaction::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  recorder.record_field("clock_period", m_clock_period, $bits(m_clock_period), UVM_DEC);
  recorder.record_field("reset_cycles", m_reset_cycles, $bits(m_reset_cycles), UVM_DEC);
endfunction : do_record
