module driver
#(
    parameter WIDTH = 8
)
(
    input wire [WIDTH-1:0] data_in, 
    input wire data_en,
    output reg [WIDTH-1:0] data_out
);
    always@(data_in, data_en)
      
      data_out = data_en ? data_in : 8'bZ;

endmodule