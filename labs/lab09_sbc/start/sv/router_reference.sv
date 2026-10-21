//------------------------------------------------------------------------------
// router_reference.sv -- reference model of the router's packet filtering
// (Lab 9B)
//
//   HBUS monitor ──port──► hbus_in (imp) : mirror maxpktsize and router_en
//   YAPP monitor ──port──► yapp_in (imp) : forward the packet on
//                                          yapp_valid_out only if the router
//                                          will route it
//
// `_yapp` was declared by router_scoreboard.sv (same package); only `_hbus`
// is new here.
//------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_hbus)

class router_reference extends uvm_component;

  // Inputs
  uvm_analysis_imp_yapp #(yapp_packet,      router_reference) m_yapp_in;
  uvm_analysis_imp_hbus #(hbus_transaction, router_reference) m_hbus_in;
  // Output: packets the router is expected to deliver
  uvm_analysis_port #(yapp_packet) m_yapp_valid_out;

  // Mirrored register fields (reset values of the DUT)
  bit[5:0] m_maxpktsize = 6'h3f;
  bit       m_router_en  = 1'b1;

  // Statistics
  int m_packets_forwarded;
  int m_dropped_disabled;
  int m_dropped_size;
  int m_dropped_addr;

  `uvm_component_utils(router_reference)

  extern function new(string name, uvm_component parent);

  // Keep the register mirror up to date from the bus traffic
  extern function void write_hbus(hbus_transaction tr);

  // Same decision the RTL makes when the header arrives
  extern function void write_yapp(yapp_packet pkt);
  extern function void report_phase(uvm_phase phase);

endclass : router_reference

//------------------------------------------------------------------------------
// router_reference -- method implementations
//------------------------------------------------------------------------------

function router_reference::new(string name, uvm_component parent);
  super.new(name, parent);
  m_yapp_in        = new("yapp_in", this);
  m_hbus_in        = new("hbus_in", this);
  m_yapp_valid_out = new("yapp_valid_out", this);
endfunction : new

//------------------------------------------------------------------------------
function void router_reference::write_hbus(hbus_transaction tr);
  if (tr.m_hwr_rd != HBUS_OP_WRITE) begin
    return;
  end
  case (tr.m_haddr)
    16'h1000: begin
      m_maxpktsize = tr.m_hdata[5:0];
      `uvm_info(get_type_name(), $sformatf("maxpktsize is now %0d", m_maxpktsize), UVM_LOW)
    end
    16'h1001: begin
      m_router_en = tr.m_hdata[0];
      `uvm_info(get_type_name(), $sformatf("router_en is now %0d", m_router_en), UVM_LOW)
    end
    default: ;
  endcase
endfunction : write_hbus

//------------------------------------------------------------------------------
function void router_reference::write_yapp(yapp_packet pkt);
  if (!m_router_en) begin
    m_dropped_disabled++;
    `uvm_info(get_type_name(), "Packet dropped: router disabled", UVM_LOW)
  end else if (pkt.m_addr == 2'd3) begin
    m_dropped_addr++;
    `uvm_info(get_type_name(), "Packet dropped: illegal address 3", UVM_LOW)
  end else if (pkt.m_length > m_maxpktsize) begin
    m_dropped_size++;
    `uvm_info(get_type_name(),
              $sformatf("Packet dropped: length %0d > maxpktsize %0d", pkt.m_length, m_maxpktsize), UVM_LOW)
  end else begin
    m_packets_forwarded++;
    m_yapp_valid_out.write(pkt);
  end
endfunction : write_yapp

//------------------------------------------------------------------------------
function void router_reference::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf({"\n--- Reference model report ---\n",
    "  forwarded to scoreboard   : %0d\n",
    "  dropped (router disabled) : %0d\n",
    "  dropped (oversized)       : %0d\n",
    "  dropped (address 3)       : %0d"},
    m_packets_forwarded, m_dropped_disabled, m_dropped_size, m_dropped_addr), UVM_LOW)
endfunction : report_phase
