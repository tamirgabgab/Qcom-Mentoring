// Lab 6 -- xrun command file
-uvmhome CDNS-1.1d
-timescale 1ns/1ns            // avoids timescale errors between files

-incdir ../../../common
-incdir ../sv
../sv/yapp_pkg.sv
../sv/yapp_if.sv              // interfaces are COMPILED, never `included
../../../router_rtl/yapp_router.sv
clkgen.sv
hw_top.sv
tb_top.sv

// Tests: base_test | short_packet_test | set_config_test |
//        incr_payload_test | exhaustive_seq_test | yapp_012_test
+UVM_TESTNAME=yapp_012_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
