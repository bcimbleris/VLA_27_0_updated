module memory
#(
    parameter AWIDTH = 5,
    parameter DWIDTH = 8
)
(
    input wire [AWIDTH-1:0] addr,
    input clk, wr, rd,
    input wire [DWIDTH-1:0] data
);
    reg [DWIDTH-1:0] mem[0:2**AWIDTH-1];

    always@(posedge clk) 
        if (wr) mem[addr] = data; 
    
    assign data = rd ? mem[addr]: 'bz; 

endmodule