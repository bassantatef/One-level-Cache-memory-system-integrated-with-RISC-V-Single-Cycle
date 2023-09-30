module RISCV_top (
    input  wire                 clk ,
    input  wire                 rst        
);

    // internal signals
    wire       [31:0]     instr     ;
    wire       [31:0]     ReadData  ;
    wire       [31:0]     PC        ;
    wire       [31:0]     DataAdr   ;
    wire       [31:0]     WriteData ;
    wire                  MemWrite  ;
    wire                  MemRead  ;

    wire                  stall     ; // To PC

processor U0_processor (
    .clk       (clk       ) ,
    .rst       (rst       ) ,
  
    .instr     (instr     ) ,
    .ReadData  (ReadData  ) ,

    .stall     (stall     ) ,

    .PC        (PC        ) ,
    .DataAdr   (DataAdr   ) ,
    .WriteData (WriteData ) ,
    .MemWrite  (MemWrite  ) ,
    .MemRead   (MemRead   )    // for cache memory
);

instr_memory U1_instr_memory (
    .address   (PC        ) ,
    .instr     (instr     ) 
);


data_mem_system U2_data_mem_sys (
    .clk         (clk         ),
    .rst         (rst         ),

    .MemRead     (MemRead     ),
    .MemWrite    (MemWrite    ),

    .WordAddress (DataAdr[9:0]),
    .DataIn      (WriteData   ),

    .stall       (stall       ),
    .DataOut     (ReadData    )
);


/*data_memory U2_data_memory (
    .clk       (clk       ) ,
    .rst       (rst       ) ,
    .WE        (MemWrite  ) ,
    .address   (DataAdr   ) ,
    .WD        (WriteData ) ,
    .RD        (ReadData  ) 
);
*/

endmodule