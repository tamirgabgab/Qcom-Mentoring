//------------------------------------------------------------------------------
// vl_waves.sv -- waveform dump for the Verilator flow (scripts/sim.py).
//
// Compiled as an extra top level next to the testbench; it does nothing unless
// the simulation is started with +waves=<file.fst> (`make sim WAVES=1`).
// xrun does not use this file: there SimVision records the waves (`make gui`).
//------------------------------------------------------------------------------

module vl_waves;
  string file;

  initial begin
    if ($value$plusargs("waves=%s", file)) begin
      $dumpfile(file);
      $dumpvars;
    end
  end
endmodule : vl_waves
