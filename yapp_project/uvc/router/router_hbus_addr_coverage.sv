//------------------------------------------------------------------------------
// router_hbus_addr_coverage.sv -- coverage of the router's HBUS address map
// (test plan COV-04)
//
//   hbus monitor ──► router_module_env.hbus_export ──► analysis_export (write)
//
// Every access, read or write, to every register, to every hole between the
// registers, and to the first, a middle and the last byte of yapp_pkt_mem, of
// the unmapped range 0x1050-0x10ff and of yapp_mem (docs/dut/spec.md, the
// register map; scripts/project_map/regmap.yaml). Accesses outside
// 0x1000-0x11ff are not binned.
//------------------------------------------------------------------------------
class router_hbus_addr_coverage extends uvm_subscriber #(hbus_transaction);

  int num_sampled;

  covergroup hbus_addr_cg with function sample(bit[15:0] addr, bit write);
    option.per_instance = 1;
    addr_cp : coverpoint addr {
      // the registers
      bins ctrl           = {16'h1000};
      bins en             = {16'h1001};
      bins parity_cnt     = {16'h1004};
      bins oversized_cnt  = {16'h1005};
      bins addr3_cnt      = {16'h1006};
      bins addr0_cnt      = {16'h1009};
      bins addr1_cnt      = {16'h100a};
      bins addr2_cnt      = {16'h100b};
      bins mem_size       = {16'h100d};
      // the unmapped addresses between them: read 0, writes ignored
      bins reg_hole[]     = {16'h1002, 16'h1003, 16'h1007, 16'h1008, 16'h100c, 16'h100e, 16'h100f};
      // yapp_pkt_mem (read-only), the unmapped range, yapp_mem (read-write)
      bins pkt_mem_first  = {16'h1010};
      bins pkt_mem_mid    = {[16'h1011:16'h104e]};
      bins pkt_mem_last   = {16'h104f};
      bins gap_first      = {16'h1050};
      bins gap_mid        = {[16'h1051:16'h10fe]};
      bins gap_last       = {16'h10ff};
      bins yapp_mem_first = {16'h1100};
      bins yapp_mem_mid   = {[16'h1101:16'h11fe]};
      bins yapp_mem_last  = {16'h11ff};
    }
    rw_cp : coverpoint write {
      bins read  = {0};
      bins write = {1};
    }
    addr_x_rw : cross addr_cp, rw_cp;
  endgroup : hbus_addr_cg

  `uvm_component_utils(router_hbus_addr_coverage)

  extern function new(string name, uvm_component parent);

  // One HBUS access from the monitor
  extern function void write(hbus_transaction t);

  extern function void report_phase(uvm_phase phase);

endclass : router_hbus_addr_coverage

//------------------------------------------------------------------------------
// router_hbus_addr_coverage -- method implementations
//------------------------------------------------------------------------------

function router_hbus_addr_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  hbus_addr_cg = new();
endfunction : new

//------------------------------------------------------------------------------
function void router_hbus_addr_coverage::write(hbus_transaction t);
  num_sampled++;
  hbus_addr_cg.sample(t.haddr, t.hwr_rd == HBUS_OP_WRITE);
endfunction : write

//------------------------------------------------------------------------------
function void router_hbus_addr_coverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("HBUS address coverage: %0d accesses sampled, coverage %.1f%%",
                                       num_sampled, hbus_addr_cg.get_inst_coverage()), UVM_LOW)
endfunction : report_phase
