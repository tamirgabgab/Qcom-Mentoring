//------------------------------------------------------------------------------
// yapp_defines.sv -- types of the YAPP UVC
//
// Every typedef and enum of the package lives here, included first by the
// package file, so the type definitions are not scattered over the classes.
// Enum values carry the enum name as prefix; the first value is always
// <NAME>_UNDEFINED and is never produced (constraints and assignments avoid it).
//------------------------------------------------------------------------------

// Which parity the driver writes: PARITY_TYPE_GOOD = correct even parity,
// PARITY_TYPE_BAD = one bit of the correct value flipped (see yapp_packet::set_parity)
typedef enum { PARITY_TYPE_UNDEFINED, PARITY_TYPE_GOOD, PARITY_TYPE_BAD } parity_type_e;

// Shorthand for the configuration database entry holding the virtual interface
typedef uvm_config_db #(virtual yapp_if) yapp_vif_config;
