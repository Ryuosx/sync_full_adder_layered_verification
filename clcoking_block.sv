`include "clcoking_block_env.sv"

module full_adder(intf.DUT intff);
always @(posedge intff.clk) begin
$display("%0t: recieved from TB: a = %d, b = %d, c = %d", $time, intff.a, intff.b, intff.c);
intff.sum <= intff.a + intff.b + intff.c;
$display("%0t: sent by DUT through cb: sum = %d", $time, intff.sum);
$display("%0t: sent by DUT through cb :carry =%d", $time, intff.carry);
end

always @(intff.sum) begin
intff.carry = intff.sum[3];
$display("%0t: actual value through interface of dut :carry =%d", $time, intff.carry); //try with strobe
end

endmodule

interface intf(input bit clk);
logic [2:0] a, b; 
logic c;
logic [3:0] sum;
logic carry;

clocking cb @(posedge clk);
input sum, carry;
output a, b, c;
endclocking

modport DUT(input a,b,c,clk, output sum, carry);
modport TB(clocking cb, input sum, carry);

endinterface

program automatic tb_full_adder(intf.TB intff);

environment env;

initial begin
env = new();
env.build(intff);

/*begin
bad_pkt_in b_pkt;
b_pkt = new();
env.gen.pkt = b_pkt;
end
*/
env.run(7);
end

endprogram


module top;

bit clk = 0;
initial forever #5 clk = ~clk;

intf intff(clk);
tb_full_adder tb(intff);
full_adder dut(intff);

endmodule
