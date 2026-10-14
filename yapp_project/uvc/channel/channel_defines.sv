//------------------------------------------------------------------------------
// channel_defines.sv -- types of the Channel UVC
//
// Every typedef and enum of the package lives here, included first by the
// package file, so the type definitions are not scattered over the classes.
// Enum values carry the enum name as prefix; the first value is always
// <NAME>_UNDEFINED and is never produced (constraints and assignments avoid it).
//------------------------------------------------------------------------------

// Parity of a packet as the output monitor saw it (the DUT forwards bad parity unchanged)
typedef enum { CHANNEL_PARITY_TYPE_UNDEFINED, CHANNEL_PARITY_TYPE_GOOD, CHANNEL_PARITY_TYPE_BAD } channel_parity_type_e;

// How a receiver answers: the delay between a header appearing on its channel
// and the receiver starting to read the packet (channel_rx_random_seq):
//   FAST    always ready (delay 0)
//   NORMAL  0..10 cycles, like channel_rx_resp_seq
//   SLOW    20..40 cycles, like channel_rx_slow_seq
//   STALLY  usually 0..10, but stall_pct of the packets wait 50..150 cycles
typedef enum { CHANNEL_RX_PROFILE_UNDEFINED, CHANNEL_RX_PROFILE_FAST, CHANNEL_RX_PROFILE_NORMAL,
               CHANNEL_RX_PROFILE_SLOW, CHANNEL_RX_PROFILE_STALLY } channel_rx_profile_e;

// Shorthand for the configuration database entry holding the virtual interface
typedef uvm_config_db #(virtual channel_if) channel_vif_config;
