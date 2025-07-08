module alu
#(
    parameter WIDTH = 8
)
(
    input wire [WIDTH-1:0] in_a, in_b,
    input wire [2:0] opcode,
    output reg [WIDTH-1:0] alu_out,
    output reg a_is_zero
);
always@(in_a, in_b, opcode)
    begin
        a_is_zero = in_a ? 1'd0 : 1'd1;
        if(opcode == 3'd000) alu_out = in_a;   else
        if(opcode == 3'd001) alu_out = in_a;   else
        if(opcode == 3'd010) alu_out = in_a + in_b; else
        if(opcode == 3'd011) alu_out = in_a & in_b; else
        if(opcode == 3'd100) alu_out = in_a ^ in_b; else
        if(opcode == 3'd101) alu_out = in_b; else
        if(opcode == 3'd110) alu_out = in_a; else
        if(opcode == 3'd111) alu_out = in_a;
    end
endmodule