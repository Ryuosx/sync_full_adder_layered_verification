`ifndef CLOCKING_BLOCK_GENERATOR
`define CLCOKING_BLOCK_GENERATOR
`include "clcoking_block_packets.sv"
import clcoking_block_packets::*;

class generator;
mailbox #(pkt_in) gen_to_drive;
pkt_in pkt;

function new(mailbox #(pkt_in) gen_to_drive);
this.gen_to_drive = gen_to_drive;
pkt = new();
endfunction

virtual task run(input int n);
repeat(n) begin
void'(pkt.randomize());
gen_to_drive.put(pkt.copy());
end
endtask

endclass

`endif

//pre_randomize and post_randomize in SystemVerilog: While pre_randomize and post_randomize are not 
//explicitly declared as virtual in SystemVerilog, they effectively behave as virtual methods when 
//called by the randomize() method. This is because the randomize() method itself is virtual. When 
//you call randomize() on a base class handle pointing to a derived class object, the virtual 
//randomize() of the derived class is invoked, and this derived randomize() then calls the derived 
//pre_randomize and post_randomize methods.