// Lab 5 -- xrun command file
-uvmhome CDNS-1.1d
-timescale 1ns/1ns

-incdir ../../../common
-incdir ../sv
../sv/yapp_pkg.sv
top.sv

// Tests: base_test | short_packet_test | set_config_test |
//        incr_payload_test | exhaustive_seq_test
+UVM_TESTNAME=exhaustive_seq_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
// Debug a randomization failure in SimVision:  xrun -f run.f -gui -access rwc
