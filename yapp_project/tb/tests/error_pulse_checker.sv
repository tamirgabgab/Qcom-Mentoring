//------------------------------------------------------------------------------
// error_pulse_checker.sv -- error_pulse_checker (used by parity_error_test)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// error_pulse_checker: a subscriber of the YAPP monitor that checks the DUT's
// `error` output. Every packet with bad parity (while the router is enabled)
// must be followed by exactly one error pulse, 1 to 10 clock cycles after the
// parity byte was accepted; a pulse with no bad packet before it is an error.
// `error` is a status pin outside every UVC interface, so it is read through
// the hardware top (hw_top.error, hw_top.clock_period).
//------------------------------------------------------------------------------
class error_pulse_checker extends uvm_subscriber #(yapp_packet);

  bit  router_en = 1'b1;                    // the test keeps this in step with en_reg[0]
  int  num_bad;                             // bad-parity packets seen
  int  num_pulses;                          // error pulses seen
  int  num_late;                            // pulses outside the 1..10 window
  time last_bad;                            // when the last bad packet was accepted
  bit  pending;                             // a pulse is owed

  `uvm_component_utils(error_pulse_checker)

  extern function new(string name, uvm_component parent);
  extern function void write(yapp_packet t);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : error_pulse_checker

//------------------------------------------------------------------------------
// error_pulse_checker -- method implementations
//------------------------------------------------------------------------------

function error_pulse_checker::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void error_pulse_checker::write(yapp_packet t);
  if (t.parity_type != BAD_PARITY || !router_en) return;
  if (pending) begin
    `uvm_error("ERR_PULSE", "a bad-parity packet ended and the pulse of the previous one is still missing")
  end
  num_bad++;
  last_bad = $time;
  pending  = 1'b1;
endfunction : write

//------------------------------------------------------------------------------
task error_pulse_checker::run_phase(uvm_phase phase);
  int cycles;
  forever begin
    @(posedge hw_top.error);
    num_pulses++;
    if (!pending) begin
      `uvm_error("ERR_PULSE", "error pulsed with no bad-parity packet before it")
      continue;
    end
    cycles = ($time - last_bad) / hw_top.clock_period;
    if (cycles < 1 || cycles > 10) begin
      num_late++;
      `uvm_error("ERR_PULSE", $sformatf("error pulsed %0d cycles after the bad packet, expected 1..10", cycles))
    end else begin
      `uvm_info("ERR_PULSE", $sformatf("error pulse %0d cycles after the bad packet", cycles), UVM_LOW)
    end
    pending = 1'b0;
  end
endtask : run_phase

//------------------------------------------------------------------------------
function void error_pulse_checker::report_phase(uvm_phase phase);
  `uvm_info("ERR_PULSE", $sformatf("error pulse report: %0d bad packets, %0d pulses, %0d outside 1..10 cycles",
                                   num_bad, num_pulses, num_late), UVM_LOW)
endfunction : report_phase
