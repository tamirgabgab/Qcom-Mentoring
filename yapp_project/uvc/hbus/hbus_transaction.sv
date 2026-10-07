//------------------------------------------------------------------------------
// hbus_transaction.sv -- one HBUS read or write
//------------------------------------------------------------------------------
typedef enum bit { HBUS_READ = 1'b0, HBUS_WRITE = 1'b1 } hbus_read_write_enum;

class hbus_transaction extends uvm_sequence_item;

  rand bit [15:0]            haddr;
  rand bit [7:0]             hdata;   // written data, or data returned by a read
  rand hbus_read_write_enum  hwr_rd;

  `uvm_object_utils_begin(hbus_transaction)
    `uvm_field_int(haddr,  UVM_ALL_ON)
    `uvm_field_int(hdata,  UVM_ALL_ON)
    `uvm_field_enum(hbus_read_write_enum, hwr_rd, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "hbus_transaction");
    super.new(name);
  endfunction : new

  function string convert2string();
    return $sformatf("%s addr=0x%04h data=0x%02h",
                     (hwr_rd == HBUS_WRITE) ? "WRITE" : "READ ", haddr, hdata);
  endfunction : convert2string

endclass : hbus_transaction
