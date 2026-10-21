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
    if (yp.m_addr != cp.m_addr) begin
      `uvm_error("PKT_COMPARE", $sformatf("Address mismatch: YAPP %0d, Channel %0d", yp.m_addr, cp.m_addr))
      ok = 0;
    end
    if (yp.m_length != cp.m_length) begin
      `uvm_error("PKT_COMPARE", $sformatf("Length mismatch: YAPP %0d, Channel %0d", yp.m_length, cp.m_length))
      ok = 0;
    end
    foreach (yp.m_payload[i]) begin
      if (i >= cp.m_payload.size()) begin
        break;
      end
      if (yp.m_payload[i] != cp.m_payload[i]) begin
        `uvm_error("PKT_COMPARE", $sformatf("Payload[%0d] mismatch: YAPP 0x%02h, Channel 0x%02h",
                                            i, yp.m_payload[i], cp.m_payload[i]))
        ok = 0;
      end
    end
    if (yp.m_parity != cp.m_parity) begin
      `uvm_error("PKT_COMPARE", $sformatf("Parity mismatch: YAPP 0x%02h, Channel 0x%02h", yp.m_parity, cp.m_parity))
      ok = 0;
    end
    return ok;
  endfunction : comp_equal

  // Optional: the same check with the uvm_comparer policy object
  function bit comp_equal_uvm(input yapp_packet yp, input channel_packet cp);
    uvm_comparer comparer = new();
    bit ok = 1;
    ok &= comparer.compare_field_int("addr",   yp.m_addr,   cp.m_addr,   2);
    ok &= comparer.compare_field_int("length", yp.m_length, cp.m_length, 6);
    ok &= comparer.compare_field_int("parity", yp.m_parity, cp.m_parity, 8);
    if (yp.m_payload.size() == cp.m_payload.size()) begin
      foreach (yp.m_payload[i]) begin
        ok &= comparer.compare_field_int($sformatf("payload[%0d]", i), yp.m_payload[i], cp.m_payload[i], 8);
      end
    end else begin
      ok = 0;
    end
    if (!ok) begin
      `uvm_error("PKT_COMPARE", "uvm_comparer found differences between the YAPP and Channel packets")
    end
    return ok;
  endfunction : comp_equal_uvm
