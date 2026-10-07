// Lab 7 -- xrun command file: every UVC adds an incdir, a package and an interface
-uvmhome CDNS-1.1d
-timescale 1ns/1ns

-incdir ../../../common

// YAPP UVC (your files from lab06_vif, now standalone in yapp/sv)
-incdir ../../../yapp/sv
../../../yapp/sv/yapp_pkg.sv
../../../yapp/sv/yapp_if.sv

// Channel UVC
-incdir ../../../channel/sv
../../../channel/sv/channel_pkg.sv
../../../channel/sv/channel_if.sv

// HBUS UVC
-incdir ../../../hbus/sv
../../../hbus/sv/hbus_pkg.sv
../../../hbus/sv/hbus_if.sv

// Clock & Reset UVC
-incdir ../../../clock_and_reset/sv
../../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../../clock_and_reset/sv/clock_and_reset_if.sv
../../../clock_and_reset/sv/clkgen.sv

// DUT and top levels
../../../router_rtl/yapp_router.sv
hw_top.sv
tb_top.sv

// Tests: base_test | simple_test | test_uvc_integration
+UVM_TESTNAME=simple_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
