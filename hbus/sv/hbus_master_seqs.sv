//------------------------------------------------------------------------------
// hbus_master_seqs.sv -- sequence library of the HBUS master
//
// Register addresses of the YAPP router (see yapp_router.sv):
//   0x1000 ctrl_reg  [5:0] maxpktsize
//   0x1001 en_reg    [0]   router_en, [7:1] counter enables
//
// One class per file: the classes live in seqs/<class>.sv and are included below.
//------------------------------------------------------------------------------

`include "seqs/hbus_base_seq.sv"
`include "seqs/hbus_write_seq.sv"
`include "seqs/hbus_read_seq.sv"
`include "seqs/hbus_set_default_regs_seq.sv"
`include "seqs/hbus_small_packet_seq.sv"
`include "seqs/hbus_large_packet_seq.sv"
`include "seqs/hbus_read_max_pkt_seq.sv"
`include "seqs/hbus_router_disable_seq.sv"
`include "seqs/hbus_router_enable_seq.sv"
