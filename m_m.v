module m_m #(parameter  WIDTH = 32,
                        DEPTH = 1024 
) 
(
    input wire                      clk,reset,        
    input wire [$clog2(DEPTH)-1:0]  address,
    input wire                      write_en,  
    input wire                      read_en,    
    input wire [WIDTH-1:0]          write_data,

    output reg                      ready, 
    output reg [WIDTH*4-1:0]        read_data 
);
    
reg [WIDTH-1:0] RAM [0:DEPTH-1] ;

reg  [1:0] count;

integer k ;
always @(posedge clk or negedge reset) 
begin
    if (!reset) 
    begin
        for ( k=0 ; k<=(DEPTH-1) ; k=k+1) 
        begin
            RAM[k] <= 'b0;
        end
        ready <= 1'b0;
        count <= 2'd3;
    end 
    else if (!(read_en ) && (write_en))
    begin
        RAM[address] <= write_data;
        count <= count - 2'd1;
        if (count == 2'b0)
        begin
            ready <= 1'b1;
            count <= 2'd3;
        end
    end 
    else if ((read_en ) && !(write_en))
    begin
        read_data <= {read_data[WIDTH*3-1:0],RAM[{address[$clog2(DEPTH)-1:2],count}]};
        count <= count - 2'd1;
        if (count == 2'b0)
        begin
            ready <= 1'b1;
            count <= 2'd3;
        end
    end 
    else begin
        ready <= 1'b0;
    end
end

endmodule