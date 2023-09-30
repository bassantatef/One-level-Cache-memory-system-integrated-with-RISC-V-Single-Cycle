module processor (
    input  wire                 clk        ,
    input  wire                 rst        ,

    input  wire     [31:0]      instr      ,
    input  wire     [31:0]      ReadData   ,

    input  wire                 stall      , // from cache to PC

    output wire     [31:0]      PC         ,
    output wire     [31:0]      DataAdr    ,  // ALUResult
    output wire     [31:0]      WriteData  ,
    output wire                 MemWrite   ,
    output wire                 MemRead       // For the cache memory

);
    
    // internal signals
    wire                        zero       ;

    wire                        PCSrc      ;
    wire            [1 :0]      ResultSrc  ;
    wire            [2 :0]      ALUControl ;
    wire                        ALUSrc     ;
    wire            [1 :0]      ImmSrc     ;
    wire                        RegWrite   ;

control_unit U0_control_unit(
    .opcode     (instr[6:0]   ) ,
    .funct3     (instr[14:12] ) ,
    .funct7     (instr[30]    ) ,
    .zero       (zero         ) ,
    
    .PCSrc      (PCSrc        ) ,
    .ResultSrc  (ResultSrc    ) ,
    .MemWrite   (MemWrite     ) ,
    .MemRead    (MemRead      ) , // for cache memory
    .ALUControl (ALUControl   ) ,
    .ALUSrc     (ALUSrc       ) ,
    .ImmSrc     (ImmSrc       ) ,
    .RegWrite   (RegWrite     )
);

Datapath U1_Datapath (
    .clk        (clk          ) ,
    .rst        (rst          ) ,

    .instr      (instr        ) ,
    .ReadData   (ReadData     ) ,
    .PCSrc      (PCSrc        ) ,
    .ResultSrc  (ResultSrc    ) ,
    .ALUControl (ALUControl   ) ,
    .ALUSrc     (ALUSrc       ) ,
    .ImmSrc     (ImmSrc       ) ,
    .RegWrite   (RegWrite     ) ,
    
    .stall      (stall        ) ,
    
    .zero       (zero         ) ,
    .PC         (PC           ) ,
    .DataAdr    (DataAdr      ) ,
    .WriteData  (WriteData    ) 
);
    
endmodule