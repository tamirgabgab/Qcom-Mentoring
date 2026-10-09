// Lab 1 -- xrun command file
// The course recommends the Cadence UVM 1.1d library; use CDNS-1.2 if you prefer.
-uvmhome CDNS-1.1d
-timescale 1ns/1ns

-incdir ../sv             // include directory for sv files
../../../common/rand_util_pkg.sv  // rnd:: random values (before the packages that use it)
../sv/yapp_pkg.sv         // compile YAPP package
top.sv                    // compile top level module
