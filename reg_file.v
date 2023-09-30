module reg_file 
(
    input  wire                      clk     ,
    input  wire                      rst     ,
    input  wire          [4:0]       A1      ,
    input  wire          [4:0]       A2      ,
    input  wire          [4:0]       A3      ,
    input  wire                      WE3     ,
    input  wire signed   [31:0]      WD3     ,

    output reg  signed   [31:0]      RD1     ,
    output reg  signed   [31:0]      RD2
);

reg signed [31:0]  RegFile [0:31] ;
integer I ;

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        for(I = 0 ; I < 32 ; I = I + 1)
        begin
            RegFile[I] <= 32'b0 ;
        end
    end
    else
    begin
        if(WE3)
        begin
            RegFile[A3] <= WD3 ;
        end
    end
end

always @(*) 
begin
    RD1 = RegFile[A1] ;
    RD2 = RegFile[A2] ;
end
    
endmodule