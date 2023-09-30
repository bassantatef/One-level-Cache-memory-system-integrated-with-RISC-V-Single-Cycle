module Datapath (
    input  wire                 clk        ,
    input  wire                 rst        ,

    input  wire     [31:0]      instr      ,
    input  wire     [31:0]      ReadData   ,

    input  wire                 PCSrc      ,
    input  wire     [1 :0]      ResultSrc  ,
    input  wire     [2 :0]      ALUControl ,
    input  wire                 ALUSrc     ,
    input  wire     [1 :0]      ImmSrc     ,
    input  wire                 RegWrite   ,
    
    input  wire                 stall      , // from cache to PC


    output wire                 zero       ,
    output wire     [31:0]      PC         ,
    output wire     [31:0]      DataAdr    ,  // ALUResult
    output wire     [31:0]      WriteData     // in_2 of ALU if sel = 0
);


    
    wire            [31:0]      SrcA       ; // in_1 of ALU
    //wire            [31:0]      SrcB_0     ; // in_2 of ALU if sel = 0
    wire            [31:0]      ImmExt     ; // in_2 of ALU if sel = 1 & in_2 of adder PCTarget
    wire            [31:0]      SrcB       ; // in_2 of ALU & output of mux2X1
      
    wire            [31:0]      Result     ; // output of mux3X1 & WD3
    wire            [31:0]      PCPlus4    ; // in_3 of mux3X1 & output of adder PCPlus4
  
    wire            [31:0]      PCTarget   ; // output of adder PCTarget and in_2 of mux2X1 of PCNext
    wire            [31:0]      PCNext     ; // output of mux2X1 and input to PC register


reg_file U0_RegFile (
    .clk        (clk          ) ,
    .rst        (rst          ) ,
    .A1         (instr[19:15] ) ,
    .A2         (instr[24:20] ) ,
    .A3         (instr[11: 7] ) ,
    .WE3        (RegWrite     ) ,
    .WD3        (Result       ) ,
    
    .RD1        (SrcA         ) ,
    .RD2        (WriteData    )     
);

mux2X1 U1_mux2X1_1 (
    .in_1       (WriteData    ) ,
    .in_2       (ImmExt       ) ,
    .sel        (ALUSrc       ) ,
      
    .out        (SrcB         )
);

ALU U2_ALU (
    .ALUControl (ALUControl   ) ,
    .A          (SrcA         ) ,
    .B          (SrcB         ) ,
       
    .result     (DataAdr      ) , // ALUResult & Address of Data Memory
    .zero       (zero         ) 
);

mux3X1 U3_mux3X1 (
    .in_1       (DataAdr      ) ,
    .in_2       (ReadData     ) ,
    .in_3       (PCPlus4      ) ,
    .sel        (ResultSrc    ) ,
      
    .out        (Result       )
);

adder U4_PCPlus4 (
    .in_1       (PC           ) ,
    .in_2       (32'd4        ) ,
            
    .out        (PCPlus4      ) 
);

adder U5_PCTarget (
    .in_1       (PC           ) ,
    .in_2       (ImmExt       ) ,
            
    .out        (PCTarget     ) 
);

mux2X1 U6_mux2X1_1 (
    .in_1       (PCPlus4      ) ,
    .in_2       (PCTarget     ) ,
    .sel        (PCSrc        ) ,
          
    .out        (PCNext       )
);

PC_reg U7_PC_reg (
    .clk        (clk          ) ,
    .rst        (rst          ) ,
    .stall      (stall        ) ,
    .PC         (PC           ) ,
    .PCNext     (PCNext       ) 
);

extend U8_extend (
    .in         (instr[31:7]  ) ,
    .ImmSrc     (ImmSrc       ) ,
    .ImmExt     (ImmExt       ) 
);

endmodule