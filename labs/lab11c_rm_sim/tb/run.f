// Lab 11C -- xrun command file: user-defined register tests
-uvmhome CDNS-1.1d
-timescale 1ns/1ns
-access +rwc                  // backdoor (peek/poke) needs read/write access to the RTL

-incdir ../../../common

// YAPP UVC
-incdir ../../../yapp/sv
../../../yapp/sv/yapp_pkg.sv
../../../yapp/sv/yapp_if.sv

// Channel UVC
-incdir ../../../channel/sv
../../../channel/sv/channel_pkg.sv
../../../channel/sv/channel_if.sv

// HBUS UVC (contains hbus_reg_adapter)
-incdir ../../../hbus/sv
../../../hbus/sv/hbus_pkg.sv
../../../hbus/sv/hbus_if.sv

// Clock & Reset UVC
-incdir ../../../clock_and_reset/sv
../../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../../clock_and_reset/sv/clock_and_reset_if.sv
../../../clock_and_reset/sv/clkgen.sv

// Router module UVC
-incdir ../../../router/sv
../../../router/sv/router_module_pkg.sv

// Register model (copied from lab11a_rm_gen)
yapp_router_reg_pkg.sv

// DUT and top levels
../../../router_rtl/yapp_router.sv
hw_top.sv
tb_top.sv

// Tests: base_test | uvm_reset_test | uvm_mem_walk_test | reg_access_test |
//        reg_function_test | reg_function_check_test | reg_introspection_test
+UVM_TESTNAME=reg_function_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
