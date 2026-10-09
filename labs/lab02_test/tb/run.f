// Lab 2 -- xrun command file
-uvmhome CDNS-1.1d
-timescale 1ns/1ns

-incdir ../sv
../../../common/rand_util_pkg.sv  // rnd:: random values (before the packages that use it)
../sv/yapp_pkg.sv
top.sv

+UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_HIGH     // try UVM_LOW: no recompile needed
