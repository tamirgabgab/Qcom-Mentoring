//------------------------------------------------------------------------------
// clock_and_reset_defines.sv -- types of the Clock & Reset UVC
//
// Every typedef and enum of the package lives here, included first by the
// package file, so the type definitions are not scattered over the classes.
// Enum values carry the enum name as prefix; the first value is always
// <NAME>_UNDEFINED and is never produced (constraints and assignments avoid it).
//------------------------------------------------------------------------------

// Shorthand for the configuration database entry holding the virtual interface
typedef uvm_config_db #(virtual clock_and_reset_if) clock_and_reset_vif_config;
