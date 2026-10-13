//------------------------------------------------------------------------------
// error_pulse_checker.sv -- error_pulse_checker (parity_error_test, the random tests)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// error_pulse_checker: a subscriber of the YAPP monitor that checks the DUT's
// `error` output. Every packet with bad parity received while the router is
// enabled (forwarded or dropped) owes exactly one error pulse, 1 to 10 clock
// cycles after its parity byte was accepted. Bad packets may overlap: a second
// one can end before the first pulse came, so the owed pulses are a queue and
// each cycle with `error` high pays the oldest one.
//   error  - a pulse with nothing owed, an owed pulse older than 10 cycles,
//            anything still owed in check_phase
// router_en comes from the reference model (`reference`), which mirrors
// en_reg from the HBUS; without it the checker assumes the router is enabled.
// `error` is a status pin outside every UVC interface, so it is read through
// the hardware top (hw_top.error, hw_top.clock, hw_top.clock_period).
//------------------------------------------------------------------------------
class error_pulse_checker extends uvm_subscriber #(yapp_packet);

  router_reference reference;               // router_en mirror (set by the test)
  int  num_bad;                             // bad-parity packets that owe a pulse
  int  num_pulses;                          // error pulses seen (cycles with error high)
  int  num_late;                            // pulses outside 1..10 cycles, or never seen
  int  max_owed;                            // most pulses owed at the same time
  time owed[$];                             // when each owed bad packet was accepted

  `uvm_component_utils(error_pulse_checker)

  extern function new(string name, uvm_component parent);
  extern function void write(yapp_packet t);
  extern task run_phase(uvm_phase phase);
  extern function void check_phase(uvm_phase phase);
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
  if (t.parity_type != BAD_PARITY) begin
    return;
  end
  if (reference != null && !reference.router_en) begin
    return;
  end
  num_bad++;
  owed.push_back($time);
  if (owed.size() > max_owed) begin
    max_owed = owed.size();
  end
endfunction : write

//------------------------------------------------------------------------------
// Sampled on the falling edge: `error` changes on the rising edge, so a high
// value here is a pulse that rose half a period earlier.
task error_pulse_checker::run_phase(uvm_phase phase);
  int  cycles;
  time rose;
  forever begin
    @(negedge hw_top.clock);
    // an owed pulse that is already too old will never be paid in time
    while (owed.size() > 0 && ($time - owed[0]) / hw_top.clock_period > 10) begin
      num_late++;
      `uvm_error("ERR_PULSE", $sformatf("no error pulse within 10 cycles of the bad packet accepted at %0t", owed[0]))
      void'(owed.pop_front());
    end
    if (hw_top.error !== 1'b1) begin
      continue;
    end
    num_pulses++;
    rose = $time - hw_top.clock_period / 2;
    if (owed.size() == 0) begin
      `uvm_error("ERR_PULSE", "error pulsed with no bad-parity packet owing a pulse")
      continue;
    end
    cycles = (rose - owed.pop_front()) / hw_top.clock_period;
    if (cycles < 1 || cycles > 10) begin
      num_late++;
      `uvm_error("ERR_PULSE", $sformatf("error pulsed %0d cycles after the bad packet, expected 1..10", cycles))
    end else begin
      `uvm_info("ERR_PULSE", $sformatf("error pulse %0d cycles after the bad packet (%0d still owed)",
                                       cycles, owed.size()), UVM_MEDIUM)
    end
  end
endtask : run_phase

//------------------------------------------------------------------------------
function void error_pulse_checker::check_phase(uvm_phase phase);
  if (owed.size() > 0) begin
    num_late += owed.size();
    `uvm_error("ERR_PULSE", $sformatf("%0d bad-parity packet(s) never got their error pulse", owed.size()))
  end
endfunction : check_phase

//------------------------------------------------------------------------------
function void error_pulse_checker::report_phase(uvm_phase phase);
  `uvm_info("ERR_PULSE", $sformatf({"error pulse report: %0d bad packets, %0d pulses, %0d outside 1..10 cycles, ",
                                    "at most %0d owed at once"}, num_bad, num_pulses, num_late, max_owed), UVM_LOW)
endfunction : report_phase
