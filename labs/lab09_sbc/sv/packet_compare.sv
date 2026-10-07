//------------------------------------------------------------------------------
// packet_compare.sv -- supplied for Lab 9A: compare a YAPP packet (what went
// into the router) with a Channel packet (what came out).
//
// The two are different classes, so the built-in compare() cannot be used
// directly. This file is `included INSIDE the scoreboard class body.
//------------------------------------------------------------------------------

  // Plain SystemVerilog comparison, one `uvm_error per difference
  function bit comp_equal(input yapp_packet yp, input channel_packet cp);
    bit ok = 1;
    if (yp.addr != cp.addr) begin
      `uvm_error("PKT_COMPARE", $sformatf("Address mismatch: YAPP %0d, Channel %0d", yp.addr, cp.addr))
      ok = 0;
    end
    if (yp.length != cp.length) begin
      `uvm_error("PKT_COMPARE", $sformatf("Length mismatch: YAPP %0d, Channel %0d", yp.length, cp.length))
      ok = 0;
    end
    foreach (yp.payload[i]) begin
      if (i >= cp.payload.size()) break;
      if (yp.payload[i] != cp.payload[i]) begin
        `uvm_error("PKT_COMPARE", $sformatf("Payload[%0d] mismatch: YAPP 0x%02h, Channel 0x%02h",
                                            i, yp.payload[i], cp.payload[i]))
        ok = 0;
      end
    end
    if (yp.parity != cp.parity) begin
      `uvm_error("PKT_COMPARE", $sformatf("Parity mismatch: YAPP 0x%02h, Channel 0x%02h", yp.parity, cp.parity))
      ok = 0;
    end
    return ok;
  endfunction : comp_equal

  // Optional: the same check with the uvm_comparer policy object
  function bit comp_equal_uvm(input yapp_packet yp, input channel_packet cp);
    uvm_comparer comparer = new();
    bit ok = 1;
    ok &= comparer.compare_field_int("addr",   yp.addr,   cp.addr,   2);
    ok &= comparer.compare_field_int("length", yp.length, cp.length, 6);
    ok &= comparer.compare_field_int("parity", yp.parity, cp.parity, 8);
    if (yp.payload.size() == cp.payload.size())
      foreach (yp.payload[i])
        ok &= comparer.compare_field_int($sformatf("payload[%0d]", i), yp.payload[i], cp.payload[i], 8);
    else
      ok = 0;
    if (!ok)
      `uvm_error("PKT_COMPARE", "uvm_comparer found differences between the YAPP and Channel packets")
    return ok;
  endfunction : comp_equal_uvm
