//------------------------------------------------------------------------------
// router_mcseq_base.sv -- router_mcseq_base (multichannel sequence library (Lab 8))
// Split out of router_mcseqs_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_mcseq_base: objection on the starting phase + p_sequencer, and the
// helpers the virtual sequences share: one HBUS write or read on the HBUS
// sequencer, and a [TEST] STAGE line
//------------------------------------------------------------------------------
class router_mcseq_base extends uvm_sequence;

  int num_reads;                            // HBUS reads done through hbus_read()

  `uvm_object_utils(router_mcseq_base)
  `uvm_declare_p_sequencer(router_mcsequencer)

  extern function new(string name = "router_mcseq_base");
  extern task pre_body();

  extern task post_body();

  extern task hbus_write(bit[15:0] addr, bit[7:0] data);
  extern task hbus_read(bit[15:0] addr, output bit[7:0] data);

  // A [TEST] STAGE line, as base_test::stage() prints it
  extern function void stage(string what);

endclass : router_mcseq_base

//------------------------------------------------------------------------------
// router_mcseq_base -- method implementations
//------------------------------------------------------------------------------

function router_mcseq_base::new(string name = "router_mcseq_base");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task router_mcseq_base::pre_body();
  uvm_phase phase = `YAPP_STARTING_PHASE;
  if (phase != null) begin
    phase.raise_objection(this, get_type_name());
  end
endtask : pre_body

//------------------------------------------------------------------------------
task router_mcseq_base::post_body();
  uvm_phase phase = `YAPP_STARTING_PHASE;
  if (phase != null) begin
    phase.drop_objection(this, get_type_name());
  end
endtask : post_body

//------------------------------------------------------------------------------
task router_mcseq_base::hbus_write(bit[15:0] addr, bit[7:0] data);
  hbus_write_seq wr;
  wr = hbus_write_seq::type_id::create("wr");
  if (!wr.randomize() with { addr == local::addr; data == local::data; }) begin
    `uvm_error(get_type_name(), "hbus_write_seq.randomize() failed")
  end
  wr.start(p_sequencer.hbus_seqr, this);
endtask : hbus_write

//------------------------------------------------------------------------------
task router_mcseq_base::hbus_read(bit[15:0] addr, output bit[7:0] data);
  hbus_read_seq rd;
  rd = hbus_read_seq::type_id::create("rd");
  if (!rd.randomize() with { addr == local::addr; }) begin
    `uvm_error(get_type_name(), "hbus_read_seq.randomize() failed")
  end
  rd.start(p_sequencer.hbus_seqr, this);
  data = rd.data;
  num_reads++;
endtask : hbus_read

//------------------------------------------------------------------------------
function void router_mcseq_base::stage(string what);
  `uvm_info("TEST", {"STAGE: ", what}, UVM_LOW)
endfunction : stage
