//------------------------------------------------------------------------------
// hbus_reg_adapter.sv -- translates register-model operations into HBUS
// transactions and back (Lab 11B)
//
//   reg2bus : uvm_reg_bus_op  -> hbus_transaction  (front-door access)
//   bus2reg : hbus_transaction -> uvm_reg_bus_op   (prediction / read data)
//
// provides_responses = 0 : the driver writes read data straight into the
// request item, so the register map reads it back from the same object.
//------------------------------------------------------------------------------
class hbus_reg_adapter extends uvm_reg_adapter;

  `uvm_object_utils(hbus_reg_adapter)

  extern function new(string name = "hbus_reg_adapter");
  extern virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);

  extern virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);

endclass : hbus_reg_adapter

//------------------------------------------------------------------------------
// hbus_reg_adapter -- method implementations
//------------------------------------------------------------------------------

function hbus_reg_adapter::new(string name = "hbus_reg_adapter");
  super.new(name);
  supports_byte_enable = 0;
  provides_responses   = 0;
endfunction : new

function uvm_sequence_item hbus_reg_adapter::reg2bus(const ref uvm_reg_bus_op rw);
  hbus_transaction tr = hbus_transaction::type_id::create("tr");
  tr.haddr  = rw.addr[15:0];
  tr.hdata  = rw.data[7:0];
  tr.hwr_rd = (rw.kind == UVM_WRITE) ? HBUS_WRITE : HBUS_READ;
  return tr;
endfunction : reg2bus

function void hbus_reg_adapter::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
  hbus_transaction tr;
  if (!$cast(tr, bus_item)) begin
    `uvm_fatal("NOT_HBUS_TYPE", "Provided bus_item is not of type hbus_transaction")
    return;
  end
  rw.kind   = (tr.hwr_rd == HBUS_WRITE) ? UVM_WRITE : UVM_READ;
  rw.addr   = tr.haddr;
  rw.data   = tr.hdata;
  rw.status = UVM_IS_OK;
endfunction : bus2reg
