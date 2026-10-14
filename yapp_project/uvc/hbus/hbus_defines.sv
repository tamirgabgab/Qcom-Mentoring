//------------------------------------------------------------------------------
// hbus_defines.sv -- types of the HBUS UVC
//
// Every typedef and enum of the package lives here, included first by the
// package file, so the type definitions are not scattered over the classes.
// Enum values carry the enum name as prefix; the first value is always
// <NAME>_UNDEFINED and is never produced (constraints and assignments avoid it).
//------------------------------------------------------------------------------

// Direction of one HBUS access (the hwr_rd wire: 0 = read, 1 = write)
typedef enum bit[1:0] { HBUS_OP_UNDEFINED, HBUS_OP_READ, HBUS_OP_WRITE } hbus_op_e;

// Shorthand for the configuration database entry holding the virtual interface
typedef uvm_config_db #(virtual hbus_if) hbus_vif_config;
