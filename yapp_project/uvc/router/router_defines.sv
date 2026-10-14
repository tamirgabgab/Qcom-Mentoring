//------------------------------------------------------------------------------
// router_defines.sv -- types of the router module UVC
//
// Every typedef and enum of the package lives here, included first by the
// package file, so the type definitions are not scattered over the classes.
// Enum values carry the enum name as prefix; the first value is always
// <NAME>_UNDEFINED and is never produced (constraints and assignments avoid it).
//------------------------------------------------------------------------------

// What router_reference decided for one packet (router_decision::reason):
// forwarded to its channel, dropped for address 3, dropped as oversized
typedef enum { ROUTER_REASON_UNDEFINED, ROUTER_REASON_FORWARDED, ROUTER_REASON_ADDR3,
               ROUTER_REASON_OVERSIZED } router_reason_e;
