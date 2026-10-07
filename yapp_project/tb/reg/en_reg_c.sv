//------------------------------------------------------------------------------
// en_reg_c.sv -- en_reg_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

//--------------------------------------------------------------------------
// en_reg : router enable and counter enables
//--------------------------------------------------------------------------
class en_reg_c extends uvm_reg;

  rand uvm_reg_field router_en;             // [0]
  rand uvm_reg_field parity_err_cnt_en;     // [1]
  rand uvm_reg_field oversized_pkt_cnt_en;  // [2]
  rand uvm_reg_field reserved;              // [3]
  rand uvm_reg_field addr0_cnt_en;          // [4]
  rand uvm_reg_field addr1_cnt_en;          // [5]
  rand uvm_reg_field addr2_cnt_en;          // [6]
  rand uvm_reg_field addr3_cnt_en;          // [7]

  `uvm_object_utils(en_reg_c)

  extern function new(string name = "en_reg_c");
  extern virtual function void build();

endclass : en_reg_c

//------------------------------------------------------------------------------
// en_reg_c -- method implementations
//------------------------------------------------------------------------------

function en_reg_c::new(string name = "en_reg_c");
  super.new(name, 8, UVM_NO_COVERAGE);
endfunction : new

function void en_reg_c::build();
  router_en            = uvm_reg_field::type_id::create("router_en");
  parity_err_cnt_en    = uvm_reg_field::type_id::create("parity_err_cnt_en");
  oversized_pkt_cnt_en = uvm_reg_field::type_id::create("oversized_pkt_cnt_en");
  reserved             = uvm_reg_field::type_id::create("reserved");
  addr0_cnt_en         = uvm_reg_field::type_id::create("addr0_cnt_en");
  addr1_cnt_en         = uvm_reg_field::type_id::create("addr1_cnt_en");
  addr2_cnt_en         = uvm_reg_field::type_id::create("addr2_cnt_en");
  addr3_cnt_en         = uvm_reg_field::type_id::create("addr3_cnt_en");
  router_en.configure           (this, 1, 0, "RW", 0, 1'b1, 1, 1, 0);
  parity_err_cnt_en.configure   (this, 1, 1, "RW", 0, 1'b0, 1, 1, 0);
  oversized_pkt_cnt_en.configure(this, 1, 2, "RW", 0, 1'b0, 1, 1, 0);
  reserved.configure            (this, 1, 3, "RW", 0, 1'b0, 1, 1, 0);
  addr0_cnt_en.configure        (this, 1, 4, "RW", 0, 1'b0, 1, 1, 0);
  addr1_cnt_en.configure        (this, 1, 5, "RW", 0, 1'b0, 1, 1, 0);
  addr2_cnt_en.configure        (this, 1, 6, "RW", 0, 1'b0, 1, 1, 0);
  addr3_cnt_en.configure        (this, 1, 7, "RW", 0, 1'b0, 1, 1, 0);
endfunction : build
