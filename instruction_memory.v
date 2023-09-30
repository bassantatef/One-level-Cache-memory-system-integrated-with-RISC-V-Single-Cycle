module instr_memory
(
    input  wire    [31:0]     address ,
    output reg     [31:0]     instr
);

//reg [31:0] instr_mem [0:99] ;
reg [7:0] instr_mem [0:99] ;

initial 
begin
    $readmemh("my_program.txt", instr_mem) ;
end
    
always @(*) 
begin
    //instr = instr_mem[address>>2] ;
    instr = {instr_mem[address], instr_mem[address+1], instr_mem[address+2], instr_mem[address+3]} ;
end

endmodule