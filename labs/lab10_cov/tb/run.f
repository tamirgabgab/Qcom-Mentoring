// Lab 10 -- xrun command file: functional coverage enabled
-uvmhome CDNS-1.1d
-timescale 1ns/1ns
-coverage U                   // collect functional (covergroup) coverage
-covoverwrite

-incdir ../../../common

// YAPP UVC (the monitor contains the covergroup)
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

// Router module UVC (final version)
-incdir ../../../yapp_project/uvc/router
../../../yapp_project/uvc/router/router_module_pkg.sv

// DUT and top levels
-F ../../../yapp_project/rtl/yapp_router.f   // the DUT: one module per file
hw_top.sv
tb_top.sv

// Tests: base_test | router_simple_mcseq_test | test_uvc_integration | coverage_test
// Analyse: xrun -f run.f -gui   ->  Windows -> Tools -> Coverage (IMC)
//          or  imc -load cov_work/scope/<test>
+UVM_TESTNAME=coverage_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
