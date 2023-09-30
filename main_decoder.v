module main_decoder 
(
    input  wire    [6:0]      opcode    ,

    output reg     [1:0]      ResultSrc ,
    output reg                MemWrite  ,
    output reg                MemRead   , // For the cache memory
    output reg                ALUSrc    ,
    output reg     [1:0]      ALUOp     ,
    output reg     [1:0]      ImmSrc    ,
    output reg                RegWrite  ,
    output reg                Branch    ,
    output reg                Jump    
);

always @(*) 
begin
    case(opcode)
    7'b0000011 : begin      // instruction: lw
        RegWrite  = 1'b1  ;
        ImmSrc    = 2'b00 ;
        ALUSrc    = 1'b1  ;
        MemWrite  = 1'b0  ;
        MemRead   = 1'b1  ; // for cache
        ResultSrc = 2'b01 ;
        Branch    = 1'b0  ;
        ALUOp     = 2'b00 ;
        Jump      = 1'b0  ;
    end
    7'b0100011 : begin      // instruction: sw
        RegWrite  = 1'b0  ;
        ImmSrc    = 2'b01 ;
        ALUSrc    = 1'b1  ;
        MemWrite  = 1'b1  ;
        MemRead   = 1'b0  ; // for cache
        ResultSrc = 2'b00 ; // don't care but I left it 00 as default
        Branch    = 1'b0  ;
        ALUOp     = 2'b00 ;
        Jump      = 1'b0  ;
    end
    7'b0110011 : begin      // instruction: R-type
        RegWrite  = 1'b1  ;
        ImmSrc    = 2'b00 ; // don't care but I left it 00 as default
        ALUSrc    = 1'b0  ;
        MemWrite  = 1'b0  ;
        MemRead   = 1'b0  ; // for cache
        ResultSrc = 2'b00 ;
        Branch    = 1'b0  ;
        ALUOp     = 2'b10 ;
        Jump      = 1'b0  ;
    end
    7'b1100011 : begin      // instruction: beq
        RegWrite  = 1'b0  ;
        ImmSrc    = 2'b10 ;
        ALUSrc    = 1'b0  ;
        MemWrite  = 1'b0  ;
        MemRead   = 1'b0  ; // for cache
        ResultSrc = 2'b00 ; // don't care but I left it 00 as default
        Branch    = 1'b1  ;
        ALUOp     = 2'b01 ;
        Jump      = 1'b0  ;
    end
    7'b0010011 : begin      // instruction: I-type ALU 
        RegWrite  = 1'b1  ;
        ImmSrc    = 2'b00 ;
        ALUSrc    = 1'b1  ;
        MemWrite  = 1'b0  ;
        MemRead   = 1'b0  ; // for cache
        ResultSrc = 2'b00 ; 
        Branch    = 1'b0  ;
        ALUOp     = 2'b10 ;
        Jump      = 1'b0  ;
    end
    7'b1101111 : begin      // instruction: jal
        RegWrite  = 1'b1  ;
        ImmSrc    = 2'b11 ;
        ALUSrc    = 1'b0  ; // don't care but I left it 0 as default
        MemWrite  = 1'b0  ;
        MemRead   = 1'b0  ; // for cache
        ResultSrc = 2'b10 ; 
        Branch    = 1'b0  ;
        ALUOp     = 2'b00 ; // don't care but I left it 00 as default
        Jump      = 1'b1  ;
    end
    default : begin
        RegWrite  = 1'b0  ;
        ImmSrc    = 2'b00 ;
        ALUSrc    = 1'b0  ;
        MemWrite  = 1'b0  ;
        MemRead   = 1'b0  ; // for cache
        ResultSrc = 2'b00 ; 
        Branch    = 1'b0  ;
        ALUOp     = 2'b00 ; 
        Jump      = 1'b0  ;
    end
    endcase
end
endmodule