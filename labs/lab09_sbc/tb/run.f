// Lab 9C -- xrun command file
-uvmhome CDNS-1.1d
-timescale 1ns/1ns

-incdir ../../../common
../../../common/rand_util_pkg.sv   // rnd:: random values, used by every UVC and test

// YAPP UVC
-incdir ../../../yapp_project/uvc/yapp
../../../yapp_project/uvc/yapp/yapp_pkg.sv
../../../yapp_project/uvc/yapp/yapp_if.sv

// Channel UVC
-incdir ../../../yapp_project/uvc/channel
../../../yapp_project/uvc/channel/channel_pkg.sv
../../../yapp_project/uvc/channel/channel_if.sv

// HBUS UVC
-incdir ../../../yapp_project/uvc/hbus
../../../yapp_project/uvc/hbus/hbus_pkg.sv
../../../yapp_project/uvc/hbus/hbus_if.sv

// Clock & Reset UVC
-incdir ../../../yapp_project/uvc/clock_and_reset
../../../yapp_project/uvc/clock_and_reset/clock_and_reset_pkg.sv
../../../yapp_project/uvc/clock_and_reset/clock_and_reset_if.sv
../../../yapp_project/uvc/clock_and_reset/clkgen.sv

// Router module UVC (needs the three packages above)
-incdir ../sv
../sv/router_module_pkg.sv

// DUT and top levels
-F ../../../yapp_project/rtl/yapp_router.f   // the DUT: one module per file
hw_top.sv
tb_top.sv

// Tests: base_test | simple_test | test_uvc_integration |
//        router_simple_mcseq_test | scoreboard_drop_test
+UVM_TESTNAME=router_simple_mcseq_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
