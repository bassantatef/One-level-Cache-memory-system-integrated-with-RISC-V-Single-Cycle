module data_memory 
( 
    input  wire                clk     ,
    input  wire                rst     ,
    input  wire                WE      ,
    input  wire    [31:0]      address ,
    input  wire    [31:0]      WD      ,
    output reg     [31:0]      RD
);

reg [31:0] data_mem [0:99] ;
integer I ;

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        for(I=0 ; I<100 ; I=I+1)
        begin
            data_mem[I] <= 32'b0 ;
        end
    end
    else
    begin
        if(WE)
        begin
            data_mem[address] <= WD ;
        end
    end
end

always @(*)
begin
    RD = data_mem[address] ;
end

endmodule