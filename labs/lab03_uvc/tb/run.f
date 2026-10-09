// Lab 3 -- xrun command file
-uvmhome CDNS-1.1d
-timescale 1ns/1ns

-incdir ../../../common      // uvm_version_compat.svh (starting_phase shim)
../../../common/rand_util_pkg.sv   // rnd:: random values, used by every UVC and test
-incdir ../sv
../sv/yapp_pkg.sv
top.sv

+UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_LOW       // UVM_HIGH shows the phase messages
+SVSEED=random               // different packets on every run
