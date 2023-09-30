module ALU 
(
    input  wire         [2 :0]    ALUControl  ,
    input  wire signed  [31:0]    A           ,
    input  wire signed  [31:0]    B           ,

    output reg  signed  [31:0]    result      ,
    output wire                   zero   
);

always @(*) 
begin
    case(ALUControl)
    3'b000  : result = A + B ;
    3'b001  : result = A - B ;
    3'b010  : result = A & B ;
    3'b011  : result = A | B ;
    3'b101  : begin
        if (A < B )
            result = 32'b1 ;
        else
            result = 32'b0 ;
    end
    default : result = 32'b0 ;
    endcase
end

assign zero = (result == 32'b0) ;

endmodule