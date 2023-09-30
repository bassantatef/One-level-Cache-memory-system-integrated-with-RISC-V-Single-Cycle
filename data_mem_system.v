module data_mem_system #(
    parameter   WIDTH           = 32,
                Size_Byte       = 512,
                Block_Size_Byte = 16, 
                DEPTH_Block     = Size_Byte/Block_Size_Byte, // 32 blocks
                words_in_ablock = Block_Size_Byte*8/WIDTH    // 4 words

) (
    input  wire                 clk         ,
    input  wire                 rst         ,

    input  wire                 MemRead     ,
    input  wire                 MemWrite    ,

    input  wire     [9:0]       WordAddress ,
    input  wire     [31:0]      DataIn      ,

    output  wire                stall       ,
    output  wire    [31:0]      DataOut      
);

    wire                        hit         ;
    wire                        ready       ;

    wire                        refill      ;
    wire                        update      ;

    wire                        main_read   ;
    wire                        main_write  ;

    wire    [WIDTH*4-1:0]       read_block  ; // (128 bits) a block output of main_mem to cache

controller cache_control_U1 (
    .clk            (clk),
    .reset          (rst),
    .hit            (hit),
    .ready          (ready),
    .mem_read       (MemRead),
    .mem_write      (MemWrite),

    .stall          (stall),
    .main_read      (main_read),
    .main_write     (main_write),
    .refill         (refill),
    .update         (update)
);

Cache_array cache_mem_U2 (
    .clk            (clk),
    .reset          (rst),
    .write_data     (DataIn),
    .write_ablock   (read_block),
    .index          (WordAddress[6:2]),
    .tag            (WordAddress[9:7]),
    .offset         (WordAddress[1:0]),
    .refill         (refill),
    .update         (update),

    .hit            (hit),
    .read_data      (DataOut)
);

m_m main_mem_U3 (
    .clk            (clk),
    .reset          (rst),
    .address        (WordAddress),
    .write_en       (main_write),
    .read_en        (main_read),
    .write_data     (DataIn),

    .ready          (ready),
    .read_data      (read_block)
);
endmodule