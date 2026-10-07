//------------------------------------------------------------------------------
// hbus_transaction.sv -- one HBUS read or write
//------------------------------------------------------------------------------
typedef enum bit { HBUS_READ = 1'b0, HBUS_WRITE = 1'b1 } hbus_read_write_enum;

class hbus_transaction extends uvm_sequence_item;

  rand bit [15:0]            haddr;
  rand bit [7:0]             hdata;   // written data, or data returned by a read
  rand hbus_read_write_enum  hwr_rd;

  `uvm_object_utils(hbus_transaction)

  // Printing, copying, comparing, packing and recording are written by hand
  // (do_print / do_copy / do_compare / do_pack / do_unpack / do_record below):
  // no uvm_field_* automation.
  extern virtual function void do_copy(uvm_object rhs);
  extern virtual function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern virtual function void do_print(uvm_printer printer);
  extern virtual function void do_pack(uvm_packer packer);
  extern virtual function void do_unpack(uvm_packer packer);
  extern virtual function void do_record(uvm_recorder recorder);
  extern function new(string name = "hbus_transaction");

  extern function string convert2string();

endclass : hbus_transaction

//------------------------------------------------------------------------------
// hbus_transaction -- method implementations
//------------------------------------------------------------------------------

function hbus_transaction::new(string name = "hbus_transaction");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
function string hbus_transaction::convert2string();
  return $sformatf("%s addr=0x%04h data=0x%02h",
                   (hwr_rd == HBUS_WRITE) ? "WRITE" : "READ ", haddr, hdata);
endfunction : convert2string

//------------------------------------------------------------------------------
function void hbus_transaction::do_copy(uvm_object rhs);
  hbus_transaction rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "do_copy: rhs is not a hbus_transaction")
  end
  super.do_copy(rhs);
  haddr  = rhs_.haddr;
  hdata  = rhs_.hdata;
  hwr_rd = rhs_.hwr_rd;
endfunction : do_copy

//------------------------------------------------------------------------------
function bit hbus_transaction::do_compare(uvm_object rhs, uvm_comparer comparer);
  hbus_transaction rhs_;
  if (!$cast(rhs_, rhs)) begin
    return 0;
  end
  do_compare = super.do_compare(rhs, comparer);
  do_compare &= comparer.compare_field_int("haddr", haddr, rhs_.haddr, $bits(haddr), UVM_HEX);
  do_compare &= comparer.compare_field_int("hdata", hdata, rhs_.hdata, $bits(hdata), UVM_HEX);
  do_compare &= comparer.compare_field_int("hwr_rd", hwr_rd, rhs_.hwr_rd, $bits(hwr_rd));
endfunction : do_compare

//------------------------------------------------------------------------------
function void hbus_transaction::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("haddr", haddr, $bits(haddr), UVM_HEX);
  printer.print_field("hdata", hdata, $bits(hdata), UVM_HEX);
  printer.print_generic("hwr_rd", "hbus_read_write_enum", $bits(hwr_rd), hwr_rd.name());
endfunction : do_print

//------------------------------------------------------------------------------
function void hbus_transaction::do_pack(uvm_packer packer);
  super.do_pack(packer);
  packer.pack_field_int(haddr, $bits(haddr));
  packer.pack_field_int(hdata, $bits(hdata));
  packer.pack_field_int(hwr_rd, $bits(hwr_rd));
endfunction : do_pack

//------------------------------------------------------------------------------
function void hbus_transaction::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  haddr = packer.unpack_field_int($bits(haddr));
  hdata = packer.unpack_field_int($bits(hdata));
  hwr_rd = hbus_read_write_enum'(packer.unpack_field_int($bits(hwr_rd)));
endfunction : do_unpack

//------------------------------------------------------------------------------
function void hbus_transaction::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  recorder.record_field("haddr", haddr, $bits(haddr), UVM_HEX);
  recorder.record_field("hdata", hdata, $bits(hdata), UVM_HEX);
  recorder.record_string("hwr_rd", hwr_rd.name());
endfunction : do_record
