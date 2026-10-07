// Lab 2 -- xrun command file
-uvmhome CDNS-1.1d
-timescale 1ns/1ns

-incdir ../sv
../sv/yapp_pkg.sv
top.sv

+UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_HIGH     // try UVM_LOW: no recompile needed
