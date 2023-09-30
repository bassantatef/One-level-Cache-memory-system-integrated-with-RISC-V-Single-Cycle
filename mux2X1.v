module mux2X1 #(parameter WIDTH = 32)
(
    input  wire   [WIDTH-1:0]    in_1  ,
    input  wire   [WIDTH-1:0]    in_2  ,
    input  wire                  sel   ,

    output reg    [WIDTH-1:0]    out  
);
    
always @(*) 
begin
    case(sel)
    1'b0 : out = in_1 ;
    1'b1 : out = in_2 ;
    endcase
end

endmodule