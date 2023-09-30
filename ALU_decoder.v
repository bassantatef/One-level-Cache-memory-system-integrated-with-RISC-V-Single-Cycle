module ALU_decoder 
(
    input  wire               op5        ,
    input  wire    [1:0]      ALUOp      ,
    input  wire    [2:0]      funct3     ,
    input  wire               funct7     ,

    output reg     [2:0]      ALUControl 
);

always @(*) 
begin
    case(ALUOp)
    2'b00   : ALUControl = 3'b000 ; // add
    2'b01   : ALUControl = 3'b001 ; // subtract
    2'b10   : begin
        case(funct3)
        3'b000  : begin
            if(op5 == 1'b1 && funct7 == 1'b1)
            begin
                ALUControl = 3'b001 ; // subtract
            end
            else
            begin
                ALUControl = 3'b000 ; // add
            end
        end
        3'b010  : ALUControl = 3'b101 ; // set less than
        3'b110  : ALUControl = 3'b011 ; // or
        3'b111  : ALUControl = 3'b010 ; // and
        default : ALUControl = 3'b000 ; // default value
        endcase
    end
    default : ALUControl = 3'b000 ; // default value
    endcase
end

endmodule