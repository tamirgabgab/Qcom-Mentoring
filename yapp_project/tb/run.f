// yapp_project -- xrun command file for the complete YAPP router verification environment
// (final state of the course: every UVC, the router module UVC, the virtual sequencer, the register model)
-uvmhome CDNS-1.1d
-timescale 1ns/1ns
-access +rwc                  // backdoor (peek/poke) needs read/write access to the RTL

-incdir ../../common

// YAPP UVC
-incdir ../uvc/yapp
../uvc/yapp/yapp_pkg.sv
../uvc/yapp/yapp_if.sv

// Channel UVC
-incdir ../uvc/channel
../uvc/channel/channel_pkg.sv
../uvc/channel/channel_if.sv

// HBUS UVC (contains hbus_reg_adapter)
-incdir ../uvc/hbus
../uvc/hbus/hbus_pkg.sv
../uvc/hbus/hbus_if.sv

// Clock & Reset UVC
-incdir ../uvc/clock_and_reset
../uvc/clock_and_reset/clock_and_reset_pkg.sv
../uvc/clock_and_reset/clock_and_reset_if.sv
../uvc/clock_and_reset/clkgen.sv

// Router module UVC
-incdir ../uvc/router
../uvc/router/router_module_pkg.sv

// Register model (generated in Lab 11A, reg/<class>.sv)
yapp_router_reg_pkg.sv

// DUT and top levels
-F ../rtl/yapp_router.f        // the DUT: one module per file
hw_top.sv
tb_top.sv

// Tests: base_test | uvm_reset_test | uvm_mem_walk_test | reg_access_test |
//        reg_function_test | reg_function_check_test | reg_introspection_test |
//        router_disable_test | router_filter_test | pkt_mem_test | reg_bit_walk_test |
//        hbus_protocol_test | backpressure_test | parity_error_test   (docs/test-plan.md)
+UVM_TESTNAME=reg_function_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
