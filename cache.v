module Cache_array #(
    parameter WIDTH           = 32,
              Size_Byte       = 512,
              Block_Size_Byte = 16, 
              DEPTH_Block     = Size_Byte/Block_Size_Byte, // 32 blocks
              words_in_ablock = Block_Size_Byte*8/WIDTH    // 4 words
) (
    input wire                                                      clk,reset,
    input wire [WIDTH-1:0]                                          write_data,
    input wire [Block_Size_Byte*8-1:0]                              write_ablock,
    input wire [$clog2(DEPTH_Block)-1:0]                            index,  // index of blocks , 5 bits
    input wire [10-$clog2(DEPTH_Block)-$clog2(words_in_ablock)-1:0] tag,    // [10-5-2-1:0] = [2:0]
    input wire [$clog2(words_in_ablock)-1:0]                        offset, // 2 bits
    input wire                                                      refill,update,

    output wire                                                     hit,
    output reg [WIDTH-1:0]                                          read_data
);
    reg		[Block_Size_Byte*8-1:0] 	CACHE		[0:DEPTH_Block-1] ;
    reg                                 valid_cache [0:DEPTH_Block-1]; 
    reg     [3-1:0]                     tag_cache   [0:DEPTH_Block-1];  

    integer k;
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        read_data <= 'b0 ;
        for ( k=0 ; k<=(DEPTH_Block-1) ; k=k+1)
        begin
            CACHE[k]        <= 'd0  ;
            tag_cache[k]    <= 3'd0 ;
            valid_cache[k]  <= 1'b0 ;
        end
    end 
    else if (update && !refill) begin  // update a full block in cache (read miss)
       CACHE[index]       <= write_ablock;
       valid_cache[index] <= 1'b1;
       tag_cache[index]   <= tag;
       //case (offset)
       //2'b00: read_data <= write_ablock[WIDTH-1:0]         ;
       //2'b01: read_data <= write_ablock[WIDTH*2-1:WIDTH]   ;
       //2'b10: read_data <= write_ablock[WIDTH*3-1:WIDTH*2] ;
       //2'b11: read_data <= write_ablock[WIDTH*4-1:WIDTH*3] ;
       //endcase
    end 
    else if (!update && refill) begin  // refill just only one word in a block (write hit)
    case (offset)
       2'b00: CACHE[index][WIDTH-1:0]          <= write_data;
       2'b01: CACHE[index][WIDTH*2-1:WIDTH]    <= write_data;
       2'b10: CACHE[index][WIDTH*3-1:WIDTH*2]  <= write_data;
       2'b11: CACHE[index][WIDTH*4-1:WIDTH*3]  <= write_data;
    endcase
    end 
    //else if (update && refill) begin  // read operation (read hit)
    //   case (offset)
    //   2'b00: read_data <= CACHE[index][WIDTH-1:0] ;
    //   2'b01: read_data <= CACHE[index][WIDTH*2-1:WIDTH] ;
    //   2'b10: read_data <= CACHE[index][WIDTH*3-1:WIDTH*2] ;
    //   2'b11: read_data <= CACHE[index][WIDTH*4-1:WIDTH*3] ;
    //   endcase
    //end 
end

always @(*) begin
    if (update && !refill) begin  // update a full block in cache (read miss) 
        case (offset)
       2'b00: read_data = write_ablock[WIDTH-1:0]         ;
       2'b01: read_data = write_ablock[WIDTH*2-1:WIDTH]   ;
       2'b10: read_data = write_ablock[WIDTH*3-1:WIDTH*2] ;
       2'b11: read_data = write_ablock[WIDTH*4-1:WIDTH*3] ;
       endcase
    end
    else if (update && refill) begin  // read operation (read hit)
       case (offset)
       2'b00: read_data = CACHE[index][WIDTH-1:0] ;
       2'b01: read_data = CACHE[index][WIDTH*2-1:WIDTH] ;
       2'b10: read_data = CACHE[index][WIDTH*3-1:WIDTH*2] ;
       2'b11: read_data = CACHE[index][WIDTH*4-1:WIDTH*3] ;
       endcase
    end
    else begin
        read_data = 'b0 ;
    end
end

assign hit = ((valid_cache[index] == 1'b1) && (tag_cache[index] == tag)) ? 1'b1 : 1'b0; 

endmodule
