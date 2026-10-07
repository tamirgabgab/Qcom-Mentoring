//------------------------------------------------------------------------------
// yapp_tx_monitor.sv -- observes packets on the YAPP input port (Lab 3/6/9A/10)
//
//   * watches the interface through a virtual interface (Lab 6)
//   * publishes every packet on item_collected_port (Lab 9A)
//   * collects functional coverage of the input traffic (Lab 10)
//------------------------------------------------------------------------------
class yapp_tx_monitor extends uvm_monitor;

  // Virtual interface, set by tb_top through yapp_vif_config
  virtual interface yapp_if vif;

  // Analysis port: the scoreboard / reference model subscribe here
  uvm_analysis_port #(yapp_packet) item_collected_port;

  // Statistics
  int num_pkt_col;
  int num_bad_parity;   // packets seen with a wrong parity byte (Lab 11C uses it)

  //--------------------------------------------------------------------------
  // Functional coverage (Lab 10)
  //   REQ1 all packet lengths, bucketed
  //   REQ2 all addresses, including the illegal one
  //   REQ3 every length bucket to every legal address with a parity error
  //--------------------------------------------------------------------------
  covergroup yapp_pkt_cg with function sample(bit [5:0] length,
                                              bit [1:0] addr,
                                              parity_type_e parity_type);
    option.per_instance = 1;
    length_cp : coverpoint length {
      bins MIN    = {1};
      bins SMALL  = {[2:10]};
      bins MEDIUM = {[11:40]};
      bins LARGE  = {[41:62]};
      bins MAX    = {63};
    }
    addr_cp : coverpoint addr {
      bins legal[]      = {[0:2]};
      bins illegal_addr = {3};
    }
    parity_cp : coverpoint parity_type;
    // REQ3: only legal addresses and only BAD_PARITY are interesting
    len_x_addr_x_parity : cross length_cp, addr_cp, parity_cp {
      ignore_bins good_parity  = binsof(parity_cp) intersect {GOOD_PARITY};
      ignore_bins illegal_addr = binsof(addr_cp.illegal_addr);
    }
  endgroup : yapp_pkt_cg

  `uvm_component_utils(yapp_tx_monitor)

  // The fields are printed by do_print() below:
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern task collect_packets();
  extern function void report_phase(uvm_phase phase);

endclass : yapp_tx_monitor

//------------------------------------------------------------------------------
// yapp_tx_monitor -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  item_collected_port = new("item_collected_port", this);
  yapp_pkt_cg = new();   // a covergroup inside a class is created with new()
endfunction : new

//------------------------------------------------------------------------------
function void yapp_tx_monitor::connect_phase(uvm_phase phase);
  if (!yapp_vif_config::get(this, "", "vif", vif)) begin
    `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
task yapp_tx_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "YAPP monitor running", UVM_LOW)
  collect_packets();
endtask : run_phase

//------------------------------------------------------------------------------
task yapp_tx_monitor::collect_packets();
  yapp_packet pkt;
  // Nothing to observe while reset is active
  @(posedge vif.clock);
  wait (vif.reset === 1'b0);
  forever begin
    // A NEW object per packet: subscribers keep the handle (analysis FIFOs
    // do not clone), so re-using one object would corrupt earlier packets.
    pkt = yapp_packet::type_id::create("pkt", this);
    vif.collect_packets(pkt.addr, pkt.length, pkt.payload, pkt.parity);
    void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
    pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
    num_pkt_col++;
    if (pkt.parity_type == BAD_PARITY) num_bad_parity++;
    `uvm_info(get_type_name(), $sformatf("Packet collected:\n%s", pkt.sprint()), UVM_LOW)
    yapp_pkt_cg.sample(pkt.length, pkt.addr, pkt.parity_type);
    item_collected_port.write(pkt);
    end_tr(pkt);
  end
endtask : collect_packets

//------------------------------------------------------------------------------
function void yapp_tx_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
            $sformatf("YAPP monitor report: %0d packets collected, coverage %.1f%%",
                      num_pkt_col, yapp_pkt_cg.get_inst_coverage()), UVM_LOW)
endfunction : report_phase

//------------------------------------------------------------------------------
function void yapp_tx_monitor::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("num_pkt_col", num_pkt_col, $bits(num_pkt_col), UVM_DEC);
endfunction : do_print
