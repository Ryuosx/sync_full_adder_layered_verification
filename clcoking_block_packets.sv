`ifndef CLCOKING_BLOCK_PACKETS
`define CLCOKING_BLOCK_PACKETS
package clcoking_block_packets;

class pkt_in;
static int count;
int pkt_id;
string pkt_in_name;
bit [3:0] sum;
bit carry;
rand bit [2:0] a, b;
rand bit c;

function new(string name = "");
pkt_in_name = name;
endfunction

extern function void post_randomize();

extern virtual function void summing();

extern virtual function pkt_in copy();

extern virtual function void display();

endclass

function void pkt_in::post_randomize();
pkt_id = ++count;
pkt_in_name = $sformatf("pkt_%0d", pkt_id);
summing();
display();
endfunction

function void pkt_in::summing();
sum = a + b + c;
carry = sum[3];
endfunction


function pkt_in pkt_in::copy();
copy = new(this.pkt_in_name);
copy.pkt_id = this.pkt_id;
copy.sum = this.sum;
copy.carry = this.carry;
copy.a = this.a;
copy.b = this.b;
copy.c = this.c;
endfunction

function void pkt_in::display();
$display("%0t: good_pkt: pkt_in_name = %s\n a = %d\n b = %d\n c = %d\n sum = %d\n carry = %d", $time, pkt_in_name, a, b, c, sum, carry);
endfunction

class bad_pkt_in extends pkt_in;

rand bit bad_pkt;

function new(string name = "");
super.new(name);
endfunction

extern function void post_randomize();

extern virtual function void summing();

extern virtual function void display();

extern virtual function bad_pkt_in copy();

endclass

function void bad_pkt_in::post_randomize();
super.post_randomize();
$display("post_randomize_of_bad_pkt_in");
endfunction

function void bad_pkt_in::summing();
super.summing();
if(bad_pkt) begin
bit [3:0] bad_sum;
do begin
bad_sum = $urandom_range(15);
end while(bad_sum == super.sum);
super.sum = bad_sum;
super.carry = bad_sum[3];
end
endfunction

function void bad_pkt_in::display();
if(!bad_pkt)
super.display();
else
$display("%0t: bad_pkt: pkt_in_name = %s\n a = %d\n b = %d\n c = %d\n sum = %d\n carry = %d", $time, super.pkt_in_name, super.a, super.b, super.c, super.sum, super.carry);
endfunction

function bad_pkt_in bad_pkt_in::copy();
copy = new(super.pkt_in_name);
copy.pkt_id = super.pkt_id;
copy.sum = super.sum;
copy.carry = super.carry;
copy.a = super.a;
copy.b = super.b;
copy.c = super.c;
copy.bad_pkt = bad_pkt;
endfunction

class pkt_out;
string pkt_out_name;
bit [3:0] sum;
bit carry;

function new(string name = "");
pkt_out_name = name;
endfunction

function void display();
$display("%0t: pkt_out: pkt_out_name = %s\n sum = %d, carry = %d", $time, pkt_out_name, sum, carry);
endfunction

endclass

endpackage

`endif