//------------------------------------------------------------------------------
// hbus_master_seqs.sv -- sequence library of the HBUS master
//
// Register addresses of the YAPP router (see yapp_router.sv):
//   0x1000 ctrl_reg  [5:0] maxpktsize
//   0x1001 en_reg    [0]   router_en, [7:1] counter enables
//------------------------------------------------------------------------------

// Base sequence: objection handling + register address constants
class hbus_base_seq extends uvm_sequence #(hbus_transaction);

  localparam bit [15:0] CTRL_REG_ADDR = 16'h1000;
  localparam bit [15:0] EN_REG_ADDR   = 16'h1001;

  `uvm_object_utils(hbus_base_seq)

  function new(string name = "hbus_base_seq");
    super.new(name);
  endfunction : new

  task pre_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.raise_objection(this, get_type_name());
  endtask : pre_body

  task post_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.drop_objection(this, get_type_name());
  endtask : post_body

endclass : hbus_base_seq


// hbus_write_seq: write `data` to `addr` (both randomizable or set by the user)
class hbus_write_seq extends hbus_base_seq;

  rand bit [15:0] addr;
  rand bit [7:0]  data;

  `uvm_object_utils(hbus_write_seq)

  function new(string name = "hbus_write_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), $sformatf("Executing hbus_write_seq addr=0x%04h data=0x%02h",
                                         addr, data), UVM_LOW)
    `uvm_do_with(req, { req.haddr == addr; req.hdata == data; req.hwr_rd == HBUS_WRITE; })
  endtask : body

endclass : hbus_write_seq


// hbus_read_seq: read `addr`; the value is left in `data`
class hbus_read_seq extends hbus_base_seq;

  rand bit [15:0] addr;
  bit [7:0]       data;

  `uvm_object_utils(hbus_read_seq)

  function new(string name = "hbus_read_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), $sformatf("Executing hbus_read_seq addr=0x%04h", addr), UVM_LOW)
    `uvm_do_with(req, { req.haddr == addr; req.hwr_rd == HBUS_READ; })
    data = req.hdata;
    `uvm_info(get_type_name(), $sformatf("Read addr=0x%04h data=0x%02h", addr, data), UVM_LOW)
  endtask : body

endclass : hbus_read_seq


// hbus_set_default_regs_seq: reset values (maxpktsize = 63, router enabled)
class hbus_set_default_regs_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_set_default_regs_seq)

  function new(string name = "hbus_set_default_regs_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing hbus_set_default_regs_seq", UVM_LOW)
    `uvm_do_with(req, { req.haddr == CTRL_REG_ADDR; req.hdata == 8'h3f; req.hwr_rd == HBUS_WRITE; })
    `uvm_do_with(req, { req.haddr == EN_REG_ADDR;   req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; })
  endtask : body

endclass : hbus_set_default_regs_seq


// hbus_small_packet_seq: accept payloads up to 20 bytes and enable the router
class hbus_small_packet_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_small_packet_seq)

  function new(string name = "hbus_small_packet_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing hbus_small_packet_seq (maxpktsize=20, router_en=1)", UVM_LOW)
    `uvm_do_with(req, { req.haddr == CTRL_REG_ADDR; req.hdata == 8'd20; req.hwr_rd == HBUS_WRITE; })
    `uvm_do_with(req, { req.haddr == EN_REG_ADDR;   req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; })
  endtask : body

endclass : hbus_small_packet_seq


// hbus_large_packet_seq: accept payloads up to 63 bytes and enable the router
class hbus_large_packet_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_large_packet_seq)

  function new(string name = "hbus_large_packet_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing hbus_large_packet_seq (maxpktsize=63, router_en=1)", UVM_LOW)
    `uvm_do_with(req, { req.haddr == CTRL_REG_ADDR; req.hdata == 8'd63; req.hwr_rd == HBUS_WRITE; })
    `uvm_do_with(req, { req.haddr == EN_REG_ADDR;   req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; })
  endtask : body

endclass : hbus_large_packet_seq


// hbus_read_max_pkt_seq: read ctrl_reg back and report maxpktsize
class hbus_read_max_pkt_seq extends hbus_base_seq;

  bit [7:0] maxpktsize;

  `uvm_object_utils(hbus_read_max_pkt_seq)

  function new(string name = "hbus_read_max_pkt_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing hbus_read_max_pkt_seq", UVM_LOW)
    `uvm_do_with(req, { req.haddr == CTRL_REG_ADDR; req.hwr_rd == HBUS_READ; })
    maxpktsize = req.hdata[5:0];
    `uvm_info(get_type_name(), $sformatf("MAXPKTSIZE register reads %0d", maxpktsize), UVM_LOW)
  endtask : body

endclass : hbus_read_max_pkt_seq


// hbus_router_disable_seq / hbus_router_enable_seq: toggle router_en only
class hbus_router_disable_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_router_disable_seq)

  function new(string name = "hbus_router_disable_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing hbus_router_disable_seq (router_en=0)", UVM_LOW)
    `uvm_do_with(req, { req.haddr == EN_REG_ADDR; req.hdata == 8'h00; req.hwr_rd == HBUS_WRITE; })
  endtask : body

endclass : hbus_router_disable_seq


class hbus_router_enable_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_router_enable_seq)

  function new(string name = "hbus_router_enable_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing hbus_router_enable_seq (router_en=1)", UVM_LOW)
    `uvm_do_with(req, { req.haddr == EN_REG_ADDR; req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; })
  endtask : body

endclass : hbus_router_enable_seq
