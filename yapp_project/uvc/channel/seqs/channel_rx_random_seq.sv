//------------------------------------------------------------------------------
// channel_rx_random_seq.sv -- sequence library of the Channel UVC
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// channel_rx_random_seq: a receiver with a profile, so each channel of a test
// can behave differently:
//   CHANNEL_RX_PROFILE_FAST    always ready (delay 0)
//   CHANNEL_RX_PROFILE_NORMAL  0..10 cycles, like channel_rx_resp_seq
//   CHANNEL_RX_PROFILE_SLOW    20..40 cycles, like channel_rx_slow_seq
//   CHANNEL_RX_PROFILE_STALLY  usually 0..10, but stall_pct of the packets wait 50..150
//              cycles: the channel stops taking packets for a while, its FIFO
//              fills and the router holds the input with in_suspend
// The wait is always before a packet (on its header), never in the middle of
// one. Like the other receiver sequences it runs forever and never raises an
// objection. A test sets one instance per channel as its default_sequence.
//------------------------------------------------------------------------------
class channel_rx_random_seq extends channel_rx_base_seq;

  channel_rx_profile_e m_profile   = CHANNEL_RX_PROFILE_NORMAL;
  int                  m_stall_pct = 15;     // CHANNEL_RX_PROFILE_STALLY: packets that wait 50..150 cycles

  `uvm_object_utils(channel_rx_random_seq)

  extern function new(string name = "channel_rx_random_seq");
  extern task body();

  // The delay of the next packet, from the profile
  extern function int pick_delay();

endclass : channel_rx_random_seq

//------------------------------------------------------------------------------
// channel_rx_random_seq -- method implementations
//------------------------------------------------------------------------------

function channel_rx_random_seq::new(string name = "channel_rx_random_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task channel_rx_random_seq::body();
  int d;
  `uvm_info(get_type_name(), $sformatf("Executing channel_rx_random_seq (forever, profile %s)", m_profile.name()),
            UVM_LOW)
  forever begin
    d   = pick_delay();
    req = channel_packet::type_id::create("req");
    req.c_delay.constraint_mode(0);         // the profile chooses the delay
    start_item(req);
    if (!req.randomize() with { req.m_delay == d; }) begin
      `uvm_error(get_type_name(), "req.randomize() failed")
    end
    finish_item(req);
  end
endtask : body

//------------------------------------------------------------------------------
function int channel_rx_random_seq::pick_delay();
  case (m_profile)
    CHANNEL_RX_PROFILE_FAST: begin
      return 0;
    end
    CHANNEL_RX_PROFILE_SLOW: begin
      return rnd::get_int(20, 40, "channel_rx_random_seq.slow");
    end
    CHANNEL_RX_PROFILE_STALLY: begin
      if (rnd::get_int(0, 99, "channel_rx_random_seq.stall") < m_stall_pct) begin
        return rnd::get_int(50, 150, "channel_rx_random_seq.stall_delay");
      end
      return rnd::get_int(0, 10, "channel_rx_random_seq.delay");
    end
    default: begin
      return rnd::get_int(0, 10, "channel_rx_random_seq.delay");
    end
  endcase
endfunction : pick_delay
