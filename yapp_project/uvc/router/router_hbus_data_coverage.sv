//------------------------------------------------------------------------------
// router_hbus_data_coverage.sv -- data patterns written to and read from
// yapp_mem (test plan COV-06)
//
//   hbus monitor ──► router_module_env.hbus_export ──► analysis_export (write)
//
// One sample per access to the scratch memory yapp_mem (0x1100-0x11ff): read
// or write, and the byte: all zeros, all ones, 0x55, 0xaa or any other value.
//------------------------------------------------------------------------------
class router_hbus_data_coverage extends uvm_subscriber #(hbus_transaction);

  int num_sampled;

  covergroup hbus_data_cg with function sample(bit write, bit [7:0] data);
    option.per_instance = 1;
    rw_cp : coverpoint write {
      bins read  = {0};
      bins write = {1};
    }
    pattern_cp : coverpoint data {
      bins zeros = {8'h00};
      bins ones  = {8'hff};
      bins x55   = {8'h55};
      bins xaa   = {8'haa};
      bins other = {[8'h01:8'h54], [8'h56:8'ha9], [8'hab:8'hfe]};
    }
    rw_x_pattern : cross rw_cp, pattern_cp;
  endgroup : hbus_data_cg

  `uvm_component_utils(router_hbus_data_coverage)

  extern function new(string name, uvm_component parent);

  // One HBUS access from the monitor; only yapp_mem counts
  extern function void write(hbus_transaction t);

  extern function void report_phase(uvm_phase phase);

endclass : router_hbus_data_coverage

//------------------------------------------------------------------------------
// router_hbus_data_coverage -- method implementations
//------------------------------------------------------------------------------

function router_hbus_data_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  hbus_data_cg = new();
endfunction : new

//------------------------------------------------------------------------------
function void router_hbus_data_coverage::write(hbus_transaction t);
  if (t.haddr < 16'h1100 || t.haddr > 16'h11ff) begin
    return;
  end
  num_sampled++;
  hbus_data_cg.sample(t.hwr_rd == HBUS_WRITE, t.hdata);
endfunction : write

//------------------------------------------------------------------------------
function void router_hbus_data_coverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("HBUS yapp_mem data coverage: %0d accesses sampled, coverage %.1f%%",
                                       num_sampled, hbus_data_cg.get_inst_coverage()), UVM_LOW)
endfunction : report_phase
