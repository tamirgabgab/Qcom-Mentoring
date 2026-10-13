//------------------------------------------------------------------------------
// router_hbus_counter_coverage.sv -- the values the counters were read with
// (test plan COV-07)
//
//   hbus monitor ──► router_module_env.hbus_export ──► analysis_export (write)
//
// One sample per HBUS read of a counter register: which of the six counters,
// and whether it read 0, a value in between or 255 (the last value before it
// wraps, docs/dut/spec.md "Decisions").
//------------------------------------------------------------------------------
class router_hbus_counter_coverage extends uvm_subscriber #(hbus_transaction);

  int num_sampled;

  covergroup hbus_counter_cg with function sample(int counter, bit [7:0] value);
    option.per_instance = 1;
    counter_cp : coverpoint counter {
      bins parity_err = {0};
      bins oversized  = {1};
      bins addr0      = {2};
      bins addr1      = {3};
      bins addr2      = {4};
      bins addr3      = {5};
    }
    value_cp : coverpoint value {
      bins zero = {8'd0};
      bins mid  = {[8'd1:8'd254]};
      bins max  = {8'd255};
    }
    counter_x_value : cross counter_cp, value_cp;
  endgroup : hbus_counter_cg

  `uvm_component_utils(router_hbus_counter_coverage)

  extern function new(string name, uvm_component parent);

  // One HBUS access from the monitor; only reads of a counter count
  extern function void write(hbus_transaction t);

  extern function void report_phase(uvm_phase phase);

endclass : router_hbus_counter_coverage

//------------------------------------------------------------------------------
// router_hbus_counter_coverage -- method implementations
//------------------------------------------------------------------------------

function router_hbus_counter_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  hbus_counter_cg = new();
endfunction : new

//------------------------------------------------------------------------------
function void router_hbus_counter_coverage::write(hbus_transaction t);
  int counter;
  if (t.hwr_rd != HBUS_READ) begin
    return;
  end
  case (t.haddr)
    16'h1004: counter = 0;
    16'h1005: counter = 1;
    16'h1009: counter = 2;
    16'h100a: counter = 3;
    16'h100b: counter = 4;
    16'h1006: counter = 5;
    default:  return;                       // not a counter
  endcase
  num_sampled++;
  hbus_counter_cg.sample(counter, t.hdata);
endfunction : write

//------------------------------------------------------------------------------
function void router_hbus_counter_coverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("HBUS counter value coverage: %0d counter reads sampled, coverage %.1f%%",
                                       num_sampled, hbus_counter_cg.get_inst_coverage()), UVM_LOW)
endfunction : report_phase
