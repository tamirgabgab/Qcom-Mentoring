//------------------------------------------------------------------------------
// rand_util_defines.sv -- types of rand_util_pkg
//
// Every typedef and enum of the package lives here, included first by the
// package file, so the type definitions are not scattered over the classes.
// Enum values carry the enum name as prefix; the first value is always
// <NAME>_UNDEFINED and is never produced (constraints and assignments avoid it).
//------------------------------------------------------------------------------

// Byte containers returned by rnd::get_bytes / rnd::get_byte_queue
typedef bit[7:0] rnd_bytes_t[];       // dynamic array of bytes
typedef bit[7:0] rnd_byte_q_t[$];     // queue of bytes
