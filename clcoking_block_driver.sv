`ifndef CLCOKING_BLOCK_DRIVER
`define CLCOKING_BLOCK_DRIVER
`include "clcoking_block_packets.sv"
import clcoking_block_packets::*;

typedef virtual intf.TB vintff;

class driver;
mailbox #(pkt_in) gen_to_drive;
vintff intff;

function new(mailbox #(pkt_in) gen_to_drive, vintff intff);
this.gen_to_drive = gen_to_drive;
this.intff = intff;
endfunction

extern task send(pkt_in pkt);

extern virtual task run(input int n);

endclass

task driver::run(input int n);
pkt_in pkt;
@intff.cb;
repeat(n) begin
gen_to_drive.get(pkt);
pkt.display(); //use pre_send method instead
send(pkt);

repeat (2) @intff.cb;

end

endtask

task driver::send(pkt_in pkt);
intff.cb.a <= pkt.a;
intff.cb.b <= pkt.b;
intff.cb.c <= pkt.c;
endtask

`endif