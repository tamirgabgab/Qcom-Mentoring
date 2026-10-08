//------------------------------------------------------------------------------
// hbus_protocol_test.sv -- hbus_protocol_test (test plan: HBUS-01..04, REG-05)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// hbus_protocol_test: the host port on the wire, without the register model.
//   1. one-cycle write to ctrl_reg, two-cycle read back: the value is there and
//      the HBUS monitor decoded exactly one write and one read
//   2. after the read the DUT releases hdata (tri-state): the bus reads 'z
//   3. unmapped addresses read 0x00 and ignore writes
//   4. a write to a read-only address (parity_err_cnt_reg) is ignored
//------------------------------------------------------------------------------
class hbus_protocol_test extends reg_access_test;

  localparam bit [15:0] UNMAPPED[8] = '{16'h1002, 16'h1003, 16'h1007, 16'h1008,
                                        16'h100c, 16'h100e, 16'h100f, 16'h1050};

  hbus_master_sequencer hbus_seqr;

  `uvm_component_utils(hbus_protocol_test)

  extern function new(string name, uvm_component parent);
  extern function void connect_phase(uvm_phase phase);
  extern virtual task access_checks();

  // Raw bus cycles through the HBUS sequencer
  extern task bus_write(bit [15:0] wr_addr, bit [7:0] wr_data);
  extern task bus_read(bit [15:0] rd_addr, output bit [7:0] rd_data);

endclass : hbus_protocol_test

//------------------------------------------------------------------------------
// hbus_protocol_test -- method implementations
//------------------------------------------------------------------------------

function hbus_protocol_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void hbus_protocol_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  hbus_seqr = tb.hbus.masters[0].sequencer;
endfunction : connect_phase

//------------------------------------------------------------------------------
task hbus_protocol_test::access_checks();
  virtual interface hbus_if vif;
  bit [7:0] data;
  int       writes_before;
  int       reads_before;
  vif = tb.hbus.monitor.vif;

  // 1. write, read back, and the monitor saw both cycles
  writes_before = tb.hbus.monitor.num_writes;
  reads_before  = tb.hbus.monitor.num_reads;
  bus_write(16'h1000, 8'h2a);
  bus_read(16'h1000, data);
  if (data != 8'h2a) begin
    `uvm_error("HBUS_PROTO", $sformatf("ctrl_reg reads 0x%02h after writing 0x2a", data))
  end
  repeat (2) @(posedge vif.clock);          // the monitor finishes the read one edge later
  if (tb.hbus.monitor.num_writes != writes_before + 1 || tb.hbus.monitor.num_reads != reads_before + 1) begin
    `uvm_error("HBUS_PROTO", $sformatf("monitor counted %0d write(s) and %0d read(s), expected 1 and 1",
                                       tb.hbus.monitor.num_writes - writes_before,
                                       tb.hbus.monitor.num_reads - reads_before))
  end

  // 2. hen is low again: the DUT must have let go of the data bus
  @(posedge vif.clock);
  if (vif.hdata_w !== 8'bz) begin
    `uvm_error("HBUS_PROTO", $sformatf("hdata is 0x%02h after the read; expected tri-state (z)", vif.hdata_w))
  end else begin
    `uvm_info("HBUS_PROTO", "hdata tri-stated after the read", UVM_NONE)
  end

  // 3. unmapped addresses: write something, read 0x00
  foreach (UNMAPPED[i]) begin
    bus_write(UNMAPPED[i], 8'ha5);
    bus_read(UNMAPPED[i], data);
    if (data != 8'h00) begin
      `uvm_error("HBUS_PROTO", $sformatf("unmapped address 0x%04h reads 0x%02h, expected 0x00", UNMAPPED[i], data))
    end
  end
  `uvm_info("HBUS_PROTO", $sformatf("%0d unmapped addresses read 0x00", $size(UNMAPPED)), UVM_NONE)

  // 4. a read-only register ignores a write
  bus_write(16'h1004, 8'h77);
  bus_read(16'h1004, data);
  if (data != 8'h00) begin
    `uvm_error("HBUS_PROTO", $sformatf("parity_err_cnt_reg reads 0x%02h after a write; a RO register must ignore it", data))
  end

  bus_write(16'h1000, 8'h3f);               // ctrl_reg back to its reset value
endtask : access_checks

//------------------------------------------------------------------------------
task hbus_protocol_test::bus_write(bit [15:0] wr_addr, bit [7:0] wr_data);
  hbus_write_seq wr;
  wr = hbus_write_seq::type_id::create("wr");
  if (!wr.randomize() with { addr == wr_addr; data == wr_data; }) begin
    `uvm_error("HBUS_PROTO", "wr.randomize() failed")
  end
  wr.start(hbus_seqr);
endtask : bus_write

//------------------------------------------------------------------------------
task hbus_protocol_test::bus_read(bit [15:0] rd_addr, output bit [7:0] rd_data);
  hbus_read_seq rd;
  rd = hbus_read_seq::type_id::create("rd");
  if (!rd.randomize() with { addr == rd_addr; }) begin
    `uvm_error("HBUS_PROTO", "rd.randomize() failed")
  end
  rd.start(hbus_seqr);
  rd_data = rd.data;
endtask : bus_read
