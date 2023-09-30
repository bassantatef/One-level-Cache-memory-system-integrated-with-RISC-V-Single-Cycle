module mux3X1 #(parameter WIDTH = 32)
(
    input  wire   [WIDTH-1:0]    in_1  ,
    input  wire   [WIDTH-1:0]    in_2  ,
    input  wire   [WIDTH-1:0]    in_3  ,
    input  wire   [1      :0]    sel   ,

    output reg    [WIDTH-1:0]    out  
);
    
always @(*) 
begin
    case(sel)
    2'b00   : out = in_1 ;
    2'b01   : out = in_2 ;
    2'b10   : out = in_3 ;
    default : out = in_1 ;
    endcase
end

endmodule