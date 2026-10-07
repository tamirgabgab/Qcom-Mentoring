// Lab 11B -- xrun command file: register model integrated
-uvmhome CDNS-1.1d
-timescale 1ns/1ns
-access +rwc                  // backdoor (peek/poke) needs read/write access to the RTL

-incdir ../../../common

// YAPP UVC
-incdir ../../../yapp_project/uvc/yapp
../../../yapp_project/uvc/yapp/yapp_pkg.sv
../../../yapp_project/uvc/yapp/yapp_if.sv

// Channel UVC
-incdir ../../../yapp_project/uvc/channel
../../../yapp_project/uvc/channel/channel_pkg.sv
../../../yapp_project/uvc/channel/channel_if.sv

// HBUS UVC (contains hbus_reg_adapter)
-incdir ../../../yapp_project/uvc/hbus
../../../yapp_project/uvc/hbus/hbus_pkg.sv
../../../yapp_project/uvc/hbus/hbus_if.sv

// Clock & Reset UVC
-incdir ../../../yapp_project/uvc/clock_and_reset
../../../yapp_project/uvc/clock_and_reset/clock_and_reset_pkg.sv
../../../yapp_project/uvc/clock_and_reset/clock_and_reset_if.sv
../../../yapp_project/uvc/clock_and_reset/clkgen.sv

// Router module UVC
-incdir ../../../yapp_project/uvc/router
../../../yapp_project/uvc/router/router_module_pkg.sv

// Register model (copied from lab11a_rm_gen)
yapp_router_reg_pkg.sv

// DUT and top levels
-F ../../../yapp_project/rtl/yapp_router.f   // the DUT: one module per file
hw_top.sv
tb_top.sv

// Tests: base_test | router_simple_mcseq_test | uvm_reset_test | uvm_mem_walk_test
// Memory error injection:  xrun -f run.f -define INJECT_ERROR
+UVM_TESTNAME=uvm_reset_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
