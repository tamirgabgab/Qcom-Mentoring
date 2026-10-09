// Lab 4 -- xrun command file
-uvmhome CDNS-1.1d
-timescale 1ns/1ns

-incdir ../../../common
../../../common/rand_util_pkg.sv   // rnd:: random values, used by every UVC and test
-incdir ../sv
../sv/yapp_pkg.sv
top.sv

// Tests: base_test | short_packet_test | set_config_test
+UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random
