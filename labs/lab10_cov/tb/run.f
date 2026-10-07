// Lab 10 -- xrun command file: functional coverage enabled
-uvmhome CDNS-1.1d
-timescale 1ns/1ns
-coverage U                   // collect functional (covergroup) coverage
-covoverwrite

-incdir ../../../common

// YAPP UVC (the monitor contains the covergroup)
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

// Router module UVC (final version)
-incdir ../../../router/sv
../../../router/sv/router_module_pkg.sv

// DUT and top levels
../../../router_rtl/yapp_router.sv
hw_top.sv
tb_top.sv

// Tests: base_test | router_simple_mcseq_test | test_uvc_integration | coverage_test
// Analyse: xrun -f run.f -gui   ->  Windows -> Tools -> Coverage (IMC)
//          or  imc -load cov_work/scope/<test>
+UVM_TESTNAME=coverage_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
