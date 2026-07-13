`ifndef CLCOKING_BLOCK_ENVIRONMENT
`define CLCOKING_BLOCK_ENVIRONMENT
`include "clcoking_block_generator.sv"
`include "clcoking_block_packets.sv"
`include "clcoking_block_driver.sv"
class environment;

generator gen;
driver drv;
mailbox #(pkt_in) gen_to_drv;

virtual function void build(vintff intff);
gen_to_drv = new();
gen = new(gen_to_drv);
drv = new(gen_to_drv, intff);
endfunction

virtual task run(int n);
fork
gen.run(n);
drv.run(n);
join_none
wait fork;

endtask

endclass

`endif
